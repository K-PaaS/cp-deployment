#!/bin/bash

export PATH=$PATH:$HOME/.local/bin
source $HOME/.bashrc

ansible-playbook -i inventory/mycluster/inventory.ini --become --become-user=root playbooks/kubeflow.yml
