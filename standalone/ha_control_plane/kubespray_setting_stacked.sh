#!/bin/bash

for ((i=0;i<$WORKER_NODE_CNT;i++))
  do
    j=$((i+1));
    find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[kube_control_plane\]/i\{WORKER${j}_NODE_HOSTNAME} ansible_host={WORKER${j}_NODE_PRIVATE_IP} ip={WORKER${j}_NODE_PRIVATE_IP}" {} \;;
    find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[calico_rr\]/i\{WORKER${j}_NODE_HOSTNAME}" {} \;;
done

sed -i "s/{MASTER1_NODE_HOSTNAME}/$MASTER1_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER1_NODE_PRIVATE_IP}/$MASTER1_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER2_NODE_HOSTNAME}/$MASTER2_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER2_NODE_PRIVATE_IP}/$MASTER2_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER3_NODE_HOSTNAME}/$MASTER3_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER3_NODE_PRIVATE_IP}/$MASTER3_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini

for ((i=0;i<$WORKER_NODE_CNT;i++))
  do
    j=$((i+1));
    eval "worker_node_hostname=\${WORKER${j}_NODE_HOSTNAME}";
    eval "worker_node_private_ip=\${WORKER${j}_NODE_PRIVATE_IP}";
    array_worker_node_ip="${array_worker_node_ip} ${worker_node_private_ip}";
    sed -i "s/{WORKER"$j"_NODE_HOSTNAME}/$worker_node_hostname/g" inventory/mycluster/inventory.ini;
    sed -i "s/{WORKER"$j"_NODE_PRIVATE_IP}/$worker_node_private_ip/g" inventory/mycluster/inventory.ini;
done

sed -i "s/{MASTER_NODE_HOSTNAME}/$MASTER1_NODE_HOSTNAME/g" roles/kubernetes-apps/metrics_server/defaults/main.yml

sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER1_NODE_PUBLIC_IP/g" roles/kubernetes/control-plane/tasks/kubeadm-setup.yml
sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER1_NODE_PUBLIC_IP/g" roles/container-engine/cri-o/defaults/main.yml

sed -i "s/{LOADBALANCER_DOMAIN}/$LOADBALANCER_DOMAIN/g" inventory/mycluster/group_vars/all/all.yml
sed -i "s/{ETCD1_NODE_PRIVATE_IP}/$MASTER1_NODE_PRIVATE_IP/g" inventory/mycluster/group_vars/all/all.yml
sed -i "s/{ETCD2_NODE_PRIVATE_IP}/$MASTER2_NODE_PRIVATE_IP/g" inventory/mycluster/group_vars/all/all.yml
sed -i "s/{ETCD3_NODE_PRIVATE_IP}/$MASTER3_NODE_PRIVATE_IP/g" inventory/mycluster/group_vars/all/all.yml

declare -a IPS=($MASTER1_NODE_PRIVATE_IP $MASTER2_NODE_PRIVATE_IP $MASTER3_NODE_PRIVATE_IP $array_worker_node_ip)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
