#!/bin/bash

rm -rf inventory/mycluster/hosts.yaml
cp inventory/mycluster/inventory.ini.terraman inventory/mycluster/inventory.ini
cp roles/kubernetes-apps/metrics_server/defaults/main.yml.ori roles/kubernetes-apps/metrics_server/defaults/main.yml
cp roles/kubernetes/control-plane/tasks/kubeadm-setup.yml.ori roles/kubernetes/control-plane/tasks/kubeadm-setup.yml
cp roles/container-engine/cri-o/defaults/main.yml.ori roles/container-engine/cri-o/defaults/main.yml

for ((i=0;i<$WORKER_NODE_CNT;i++))
  do
    j=$((i+1));
    find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[kube_control_plane\]/i\{WORKER${j}_NODE_HOSTNAME} ansible_host={WORKER${j}_NODE_PUBLIC_IP} ip={WORKER${j}_NODE_PRIVATE_IP}" {} \;;
    find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[kube_node\]/a\{WORKER${j}_NODE_HOSTNAME}" {} \;;
done

sed -i "s/{MASTER_NODE_HOSTNAME}/$MASTER_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER_NODE_PRIVATE_IP}/$MASTER_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER_NODE_PUBLIC_IP/g" inventory/mycluster/inventory.ini

ARRAY_WORKER_NODE_IP=""

for ((i=0;i<$WORKER_NODE_CNT;i++))
  do
    j=$((i+1));
    eval "worker_node_hostname=\${WORKER${j}_NODE_HOSTNAME}";
    eval "worker_node_private_ip=\${WORKER${j}_NODE_PRIVATE_IP}";
    eval "worker_node_public_ip=\${WORKER${j}_NODE_PUBLIC_IP}";
    ARRAY_WORKER_NODE_IP="${ARRAY_WORKER_NODE_IP} ${worker_node_public_ip}";
    sed -i "s/{WORKER"$j"_NODE_HOSTNAME}/$worker_node_hostname/g" inventory/mycluster/inventory.ini;
    sed -i "s/{WORKER"$j"_NODE_PRIVATE_IP}/$worker_node_private_ip/g" inventory/mycluster/inventory.ini;
    sed -i "s/{WORKER"$j"_NODE_PUBLIC_IP}/$worker_node_public_ip/g" inventory/mycluster/inventory.ini;
done

sed -i "s/{MASTER_NODE_HOSTNAME}/$MASTER_NODE_HOSTNAME/g" roles/kubernetes-apps/metrics_server/defaults/main.yml

sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER_NODE_PUBLIC_IP/g" roles/kubernetes/control-plane/tasks/kubeadm-setup.yml
sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER_NODE_PUBLIC_IP/g" roles/container-engine/cri-o/defaults/main.yml

cp $HOME/.ssh/$CLUSTER_PRIVATE_KEY $HOME/.ssh/id_rsa
cp $HOME/.ssh/$CLUSTER_PRIVATE_KEY.pub $HOME/.ssh/id_rsa.pub

declare -a IPS=($MASTER_NODE_PUBLIC_IP $ARRAY_WORKER_NODE_IP)
echo ${IPS[@]}
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

sed -i "s/ip: $MASTER_NODE_PUBLIC_IP/ip: $MASTER_NODE_PRIVATE_IP/g" inventory/mycluster/hosts.yaml
sed -i "s/access_ip: $MASTER_NODE_PUBLIC_IP/access_ip: $MASTER_NODE_PRIVATE_IP/g" inventory/mycluster/hosts.yaml

for ((i=0;i<$WORKER_NODE_CNT;i++))
  do
    j=$((i+1));
    eval "worker_node_public_ip=\${WORKER${j}_NODE_PUBLIC_IP}";
    eval "worker_node_private_ip=\${WORKER${j}_NODE_PRIVATE_IP}";
    sed -i "s/ip: $worker_node_public_ip/ip: $worker_node_private_ip/g" inventory/mycluster/hosts.yaml;
    sed -i "s/access_ip: $worker_node_public_ip/access_ip: $worker_node_private_ip/g" inventory/mycluster/hosts.yaml;
done
