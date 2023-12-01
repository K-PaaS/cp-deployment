#!/bin/bash

sudo chmod o+w /tmp
sudo chmod o+w /var/tmp

# Registering Container Platform, Edge ENV
source cp-cluster-vars.sh
source cp-edge-vars.sh

result=0

if [ "$CLOUDCORE_VIP" == "" ]; then
  echo "CLOUDCORE_VIP is empty. Enter a variable."
  result=2
elif [[ ! "$CLOUDCORE_VIP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "CLOUDCORE_VIP is not a value in IP format. Enter a IP format variable."
  result=2
elif [ "$CLOUDCORE1_NODE_HOSTNAME" == "" ]; then
  echo "  is empty. Enter a variable."
  result=2
elif [ "$CLOUDCORE2_NODE_HOSTNAME" == "" ]; then
  echo "  is empty. Enter a variable."
  result=2
fi

if [ "$result" == 2 ]; then
  return $result
fi

if [ "$EDGE_HOSTS" == "" ]; then
  echo "EDGE_HOSTS is empty. Enter a variable."
  result=2
elif [[ ! "$EDGE_HOSTS" =~ ^[0-9]+$ ]]; then
  echo "EDGE_HOSTS is not a value in Number format. Enter a Number format variable."
  result=2
elif [ "$EDGE_HOSTS" -eq 0 ]; then
  echo "The minimum value of the EDGE_HOSTS variable is 1."
  result=2
elif [ ! "$EDGE_HOSTS" == "" ]; then
  for ((i=0;i<$EDGE_HOSTS;i++))
    do
      j=$((i+1));
      eval "edge_node_hostname=\${EDGE${j}_NODE_HOSTNAME}";
      eval "edge_node_private_ip=\${EDGE${j}_NODE_PRIVATE_IP}";

      if [ "$edge_node_hostname" == "" ]; then
        echo "EDGE${j}_NODE_HOSTNAME is empty. Enter a variable."
        result=2
        break
      elif [ "$edge_node_private_ip" == "" ]; then
        echo "EDGE${j}_NODE_PRIVATE_IP is empty. Enter a variable."
        result=2
        break
      elif [[ ! "$edge_node_private_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "EDGE${j}_NODE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
        result=2
        break
      fi
  done
fi

if [ "$result" == 2 ]; then
  return $result
fi

# Container Platform Edge configuration settings
cat << EOF > inventory/mycluster/edge-hosts.yaml
all:
  hosts:
    $MASTER1_NODE_HOSTNAME:
      ansible_host: $MASTER1_NODE_PRIVATE_IP
      ip: $MASTER1_NODE_PRIVATE_IP
      access_ip: $MASTER1_NODE_PRIVATE_IP
EOF

for ((i=0;i<$EDGE_HOSTS;i++))
  do
    j=$((i+1));
    eval "edge_node_hostname=\${EDGE${j}_NODE_HOSTNAME}";
    eval "edge_node_private_ip=\${EDGE${j}_NODE_PRIVATE_IP}";

cat << EOF >> inventory/mycluster/edge-hosts.yaml
    $edge_node_hostname:
      ansible_host: $edge_node_private_ip
      ip: $edge_node_private_ip
      access_ip: $edge_node_private_ip
EOF
done

cat << EOF >> inventory/mycluster/edge-hosts.yaml
  children:
    cloudcore_node:
      hosts:
        $MASTER1_NODE_HOSTNAME:
    edge_node:
      hosts:
EOF

for ((i=0;i<$EDGE_HOSTS;i++))
  do
    j=$((i+1));
    eval "edge_node_hostname=\${EDGE${j}_NODE_HOSTNAME}";
    eval "edge_node_private_ip=\${EDGE${j}_NODE_PRIVATE_IP}";

cat << EOF >> inventory/mycluster/edge-hosts.yaml
        $edge_node_hostname:
EOF
done

cat << EOF > roles/cp/edge/keadm_init/defaults/main.yml
cloudcore1_node_hostname: {CLOUDCORE1_NODE_HOSTNAME}
cloudcore2_node_hostname: {CLOUDCORE2_NODE_HOSTNAME}
EOF

cat << EOF > roles/cp/edge/keadm_join/defaults/main.yml
cloudcore_vip: {CLOUDCORE_VIP}
EOF

sed -i "s/{CLOUDCORE1_NODE_HOSTNAME}/$CLOUDCORE1_NODE_HOSTNAME/g" roles/cp/edge/keadm_init/defaults/main.yml
sed -i "s/{CLOUDCORE2_NODE_HOSTNAME}/$CLOUDCORE2_NODE_HOSTNAME/g" roles/cp/edge/keadm_init/defaults/main.yml

sed -i "s/{CLOUDCORE_VIP}/$CLOUDCORE_VIP/g" roles/cp/edge/keadm_join/defaults/main.yml

sed -i "s/{MASTER_NODE_HOSTNAME}/$MASTER1_NODE_HOSTNAME/g" ../edge/edgemesh/agent/04-configmap.yaml
sed -i "s/{CLOUDCORE_VIP}/$CLOUDCORE_VIP/g" ../edge/edgemesh/agent/04-configmap.yaml

sed -i "s/{CLOUDCORE_VIP}/$CLOUDCORE_VIP/g" ../edge/ha-cloudcore/02-ha-configmap.yaml

# Deploy Container Platform Edge
ansible-playbook -i inventory/mycluster/edge-hosts.yaml  --become --become-user=root playbooks/edge.yml
