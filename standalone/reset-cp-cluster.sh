#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/ubuntu/.local/bin
source /home/ubuntu/.bashrc

ansible-playbook -i inventory/mycluster/hosts.yaml -e reset_confirmation=yes  --become --become-user=root reset.yml
