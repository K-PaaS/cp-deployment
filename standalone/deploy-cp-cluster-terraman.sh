#!/bin/bash

OS_VERSION=$(cat /etc/lsb-release | grep DISTRIB_RELEASE | awk -F '=' '{print $2}')

# Registering container platform variable
source cp-cluster-terraman-vars.sh

# Container platform configuration settings
sed -i "s/metallb_enabled:.*/metallb_enabled: false/" inventory/mycluster/group_vars/k8s_cluster/addons.yml

if [ "$OS_VERSION" == "24.04" ]; then
  source $HOME/kpaas-venv/bin/activate
else
  export PATH=$PATH:$HOME/.local/bin
  source $HOME/.bashrc
fi

# Deploy container platform
ansible-playbook -i inventory/mycluster/hosts-$CLUSTER_NAME.yaml -e master1_node_public_ip=$MASTER1_NODE_PUBLIC_IP --become --become-user=root playbooks/cluster_terraman.yml
