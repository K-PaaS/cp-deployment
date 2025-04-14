#!/bin/bash

ansible-playbook -i inventory/mycluster/inventory.ini  --become --become-user=root playbooks/kubeflow.yml
