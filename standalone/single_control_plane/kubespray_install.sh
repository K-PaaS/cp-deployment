#!/bin/bash

ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml

mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
