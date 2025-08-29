#!/bin/bash

export PATH=$PATH:$HOME/.local/bin
source $HOME/.bashrc

ansible-playbook -i inventory/mycluster/inventory.ini -e reset_confirmation=yes  --become --become-user=root reset.yml
