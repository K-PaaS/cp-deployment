#!/bin/bash

sudo chmod o+w /tmp
sudo chmod o+w /var/tmp

# Registering Container Platform, Edge ENV
source cp-cluster-vars.sh
source cp-edge-vars.sh

result=0

if [ "$CLOUDCORE_PRIVATE_IP" == "" ]; then
  echo "CLOUDCORE_PRIVATE_IP is empty. Enter a variable."
  result=2
elif [[ ! "$CLOUDCORE_PRIVATE_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "CLOUDCORE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
  result=2
elif [ "$CLOUDCORE_PUBLIC_IP" == "" ]; then
  echo "CLOUDCORE_PUBLIC_IP is empty. Enter a variable."
  result=2
elif [[ ! "$CLOUDCORE_PUBLIC_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "CLOUDCORE_PUBLIC_IP is not a value in IP format. Enter a IP format variable."
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
      eval "edge_node_public_ip=\${EDGE${j}_NODE_PUBLIC_IP}";

      if [ "$edge_node_hostname" == "" ]; then
        echo "EDGE${j}_NODE_HOSTNAME is empty. Enter a variable."
        result=2
        break
      elif [ "$edge_node_public_ip" == "" ]; then
        echo "EDGE${j}_NODE_PUBLIC_IP is empty. Enter a variable."
        result=2
        break
      elif [[ ! "$edge_node_public_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "EDGE${j}_NODE_PUBLIC_IP is not a value in IP format. Enter a IP format variable."
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
    eval "edge_node_public_ip=\${EDGE${j}_NODE_PUBLIC_IP}";

cat << EOF >> inventory/mycluster/edge-hosts.yaml
    $edge_node_hostname:
      ansible_host: $edge_node_public_ip
      ip: $edge_node_public_ip
      access_ip: $edge_node_public_ip
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
    eval "edge_node_public_ip=\${EDGE${j}_NODE_PUBLIC_IP}";

cat << EOF >> inventory/mycluster/edge-hosts.yaml
        $edge_node_hostname:
EOF
done

cat << EOF > roles/cp/edge/keadm_init/defaults/main.yml
cloudcore_private_ip: $CLOUDCORE_PRIVATE_IP
cloudcore_public_ip: $CLOUDCORE_PUBLIC_IP
EOF

cat << EOF > roles/cp/edge/keadm_join/defaults/main.yml
cloudcore_public_ip: $CLOUDCORE_PUBLIC_IP
EOF

sed -i "s/{MASTER_NODE_HOSTNAME}/$MASTER1_NODE_HOSTNAME/" ../edge/edgemesh/agent/04-configmap.yaml
sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER1_NODE_PUBLIC_IP/" ../edge/edgemesh/agent/04-configmap.yaml

# Deploy Container Platform Edge
ansible-playbook -i inventory/mycluster/edge-hosts.yaml  --become --become-user=root playbooks/edge.yml
