#!/bin/bash
  
sed -i "s/{MASTER1_NODE_HOSTNAME}/$MASTER1_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER1_NODE_PRIVATE_IP}/$MASTER1_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER2_NODE_HOSTNAME}/$MASTER2_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER2_NODE_PRIVATE_IP}/$MASTER2_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER3_NODE_HOSTNAME}/$MASTER3_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER3_NODE_PRIVATE_IP}/$MASTER3_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{ETCD1_NODE_HOSTNAME}/$ETCD1_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{ETCD1_NODE_PRIVATE_IP}/$ETCD1_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{ETCD2_NODE_HOSTNAME}/$ETCD2_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{ETCD2_NODE_PRIVATE_IP}/$ETCD2_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{ETCD3_NODE_HOSTNAME}/$ETCD3_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{ETCD3_NODE_PRIVATE_IP}/$ETCD3_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER1_NODE_HOSTNAME}/$WORKER1_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER1_NODE_PRIVATE_IP}/$WORKER1_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER2_NODE_HOSTNAME}/$WORKER2_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER2_NODE_PRIVATE_IP}/$WORKER2_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER3_NODE_HOSTNAME}/$WORKER3_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER3_NODE_PRIVATE_IP}/$WORKER3_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini

sed -i "s/{MASTER_NODE_HOSTNAME}/$MASTER1_NODE_HOSTNAME/g" roles/kubernetes-apps/metrics_server/defaults/main.yml

sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER1_NODE_PUBLIC_IP/g" roles/kubernetes/control-plane/tasks/kubeadm-setup.yml

sed -i "s/{LOADBALANCER_DOMAIN}/$LOADBALANCER_DOMAIN/g" inventory/mycluster/group_vars/all/all.yml
sed -i "s/{ETCD1_NODE_PRIVATE_IP}/$ETCD1_NODE_PRIVATE_IP/g" inventory/mycluster/group_vars/all/all.yml
sed -i "s/{ETCD2_NODE_PRIVATE_IP}/$ETCD2_NODE_PRIVATE_IP/g" inventory/mycluster/group_vars/all/all.yml
sed -i "s/{ETCD3_NODE_PRIVATE_IP}/$ETCD3_NODE_PRIVATE_IP/g" inventory/mycluster/group_vars/all/all.yml

declare -a IPS=($MASTER1_NODE_PRIVATE_IP $MASTER2_NODE_PRIVATE_IP $MASTER3_NODE_PRIVATE_IP $ETCD1_NODE_PRIVATE_IP $ETCD2_NODE_PRIVATE_IP $ETCD3_NODE_PRIVATE_IP $WORKER1_NODE_PRIVATE_IP $WORKER2_NODE_PRIVATE_IP $WORKER3_NODE_PRIVATE_IP)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

sed -i "/kube_node:/,/etcd:/s/$ETCD1_NODE_HOSTNAME://g" inventory/mycluster/hosts.yaml
sed -i "/kube_node:/,/etcd:/s/$ETCD2_NODE_HOSTNAME://g" inventory/mycluster/hosts.yaml
sed -i "/kube_node:/,/etcd:/s/$ETCD3_NODE_HOSTNAME://g" inventory/mycluster/hosts.yaml
sed -i "/^ *$/d" inventory/mycluster/hosts.yaml

sed -i "/etcd:/,/k8s_cluster:/s/$MASTER1_NODE_HOSTNAME/$ETCD1_NODE_HOSTNAME/g" inventory/mycluster/hosts.yaml
sed -i "/etcd:/,/k8s_cluster:/s/$MASTER2_NODE_HOSTNAME/$ETCD2_NODE_HOSTNAME/g" inventory/mycluster/hosts.yaml
sed -i "/etcd:/,/k8s_cluster:/s/$MASTER3_NODE_HOSTNAME/$ETCD3_NODE_HOSTNAME/g" inventory/mycluster/hosts.yaml
