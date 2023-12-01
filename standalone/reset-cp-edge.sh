#!/bin/bash

ansible-playbook -i inventory/mycluster/edge-hosts.yaml -e reset_confirmation=yes  --become --become-user=root playbooks/reset_edge.yml
