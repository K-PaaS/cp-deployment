#!/bin/bash

MODE="$1"

export PATH=$PATH:$HOME/.local/bin
source $HOME/.bashrc

if [ "$MODE" == "single" ]; then
  ansible-playbook -i localhost, -c local -e mode=single playbooks/local.yml
  PRE_RET=$?
  if [ $PRE_RET -ne 0 ]; then
    exit 1
  else
    ansible-playbook -i inventory/mycluster/inventory.ini -e reset_confirmation=yes --become --become-user=root reset.yml
  fi
elif [ "$MODE" == "multi" ]; then
  CLUSTER_CNT="$2"
  for i in $(seq 1 $CLUSTER_CNT); do
    ansible-playbook -i localhost, -c local -e mode=multi -e cluster_no=$i --become --become-user=root playbooks/local.yml
    PRE_RET=$?
    if [ $PRE_RET -ne 0 ]; then
      exit 1
    else
      ansible-playbook -i inventory/mycluster/inventory.ini -e reset_confirmation=yes --become --become-user=root reset.yml
    fi
  done
elif [ "$MODE" == "federation" ]; then
  ansible-playbook -i localhost, -c local -e mode=single playbooks/local.yml
  PRE_RET=$?
  if [ $PRE_RET -ne 0 ]; then
    exit 1
  else
    ansible-playbook -i inventory/mycluster/inventory.ini -e reset_confirmation=yes --become --become-user=root reset.yml
  fi

  CLUSTER_CNT="$2"
  for i in $(seq 1 $CLUSTER_CNT); do
    ansible-playbook -i localhost, -c local -e mode=multi -e cluster_no=$i --become --become-user=root playbooks/local.yml
    PRE_RET=$?
    if [ $PRE_RET -ne 0 ]; then
      exit 1
    else
      ansible-playbook -i inventory/mycluster/inventory.ini -e reset_confirmation=yes --become --become-user=root reset.yml
    fi
  done
fi
