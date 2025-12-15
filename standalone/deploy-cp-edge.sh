#!/bin/bash

OS_VERSION=$(cat /etc/lsb-release | grep DISTRIB_RELEASE | awk -F '=' '{print $2}')

if [ "$OS_VERSION" == "24.04" ]; then
  source $HOME/kpaas-venv/bin/activate
else
  export PATH=$PATH:$HOME/.local/bin
  source $HOME/.bashrc
fi

ansible-playbook -i localhost, -c local playbooks/local-edge.yml
RET=$?
if [ "$RET" -ne 0 ]; then
  exit 1
else
  ansible-playbook -i inventory/mycluster/edge-hosts.yaml --become --become-user=root playbooks/edge.yml
fi