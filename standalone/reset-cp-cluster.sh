#!/bin/bash

ansible-playbook -i inventory/mycluster/hosts.yaml -e reset_confirmation=yes  --become --become-user=root reset.yml