#!/bin/bash

# Registering container platform variable
source cp-cluster-terraman-vars.sh

# Container platform configuration settings
cp roles/kubernetes/control-plane/tasks/kubeadm-setup.yml.ori roles/kubernetes/control-plane/tasks/kubeadm-setup.yml
cp roles/kubernetes-apps/metrics_server/defaults/main.yml.ori roles/kubernetes-apps/metrics_server/defaults/main.yml

sed -i "s/{MASTER1_NODE_HOSTNAME}/$MASTER1_NODE_HOSTNAME/g" roles/kubernetes-apps/metrics_server/defaults/main.yml
sed -i "s/{MASTER1_NODE_PUBLIC_IP}/$MASTER1_NODE_PUBLIC_IP/g" roles/kubernetes/control-plane/tasks/kubeadm-setup.yml

sed -i "s/metallb_enabled: true/metallb_enabled: false/g" inventory/mycluster/group_vars/k8s_cluster/addons.yml

cp $HOME/.ssh/$CLUSTER_PRIVATE_KEY $HOME/.ssh/id_rsa
cp $HOME/.ssh/$CLUSTER_PRIVATE_KEY.pub $HOME/.ssh/id_rsa.pub

# Deploy container platform
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root playbooks/cluster_terraman.yml
