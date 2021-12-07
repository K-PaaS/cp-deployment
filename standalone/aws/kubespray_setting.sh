#!/bin/bash

sed -i "s/{MASTER_NODE_HOSTNAME}/$MASTER_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER_NODE_PRIVATE_IP}/$MASTER_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER1_NODE_HOSTNAME}/$WORKER1_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER1_NODE_PRIVATE_IP}/$WORKER1_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER2_NODE_HOSTNAME}/$WORKER2_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER2_NODE_PRIVATE_IP}/$WORKER2_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER3_NODE_HOSTNAME}/$WORKER3_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{WORKER3_NODE_PRIVATE_IP}/$WORKER3_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini

sed -i "s/{MASTER_NODE_HOSTNAME}/$MASTER_NODE_HOSTNAME/g" roles/kubernetes-apps/metrics_server/defaults/main.yml

sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER_NODE_PUBLIC_IP/g" roles/kubernetes/control-plane/tasks/kubeadm-setup.yml

declare -a IPS=($MASTER_NODE_PRIVATE_IP $WORKER1_NODE_PRIVATE_IP $WORKER2_NODE_PRIVATE_IP $WORKER3_NODE_PRIVATE_IP)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
