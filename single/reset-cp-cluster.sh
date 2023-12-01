#!/bin/bash

# Reset Container Platform
ansible-playbook -i hosts.yaml  --become --become-user=root reset.yml

