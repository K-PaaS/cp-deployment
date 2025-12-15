#!/bin/bash

MODE="$1"

OS_VERSION=$(cat /etc/lsb-release | grep DISTRIB_RELEASE | awk -F '=' '{print $2}')

if [ "$OS_VERSION" == "24.04" ]; then
  source $HOME/kpaas-venv/bin/activate
else
  export PATH=$PATH:$HOME/.local/bin
  source $HOME/.bashrc
fi

if [ "$MODE" == "single" ]; then
  ansible-playbook -i localhost, -c local -e mode=single playbooks/local.yml
  RET=$?
  if [ "$RET" -ne 0 ]; then
    exit 1
  else
    ansible-playbook -i inventory/mycluster/inventory.ini -e reset_confirmation=yes --become --become-user=root reset.yml
    RET=$?
    if [ "$RET" -ne 0 ]; then
      exit 1
    fi
  fi
elif [ "$MODE" == "multi" ]; then
  CLUSTER_CNT="$2"
  for i in $(seq 1 $CLUSTER_CNT); do
    ansible-playbook -i localhost, -c local -e mode=multi -e cluster_no=$i --become --become-user=root playbooks/local.yml
    RET=$?
    if [ "$RET" -ne 0 ]; then
      exit 1
    else
      ansible-playbook -i inventory/mycluster/inventory.ini -e reset_confirmation=yes --become --become-user=root reset.yml
      RET=$?
      if [ "$RET" -ne 0 ]; then
        exit 1
      fi
    fi
  done
elif [ "$MODE" == "federation" ]; then
  ansible-playbook -i localhost, -c local -e mode=single playbooks/local.yml
  RET=$?
  if [ "$RET" -ne 0 ]; then
    exit 1
  else
    ansible-playbook -i inventory/mycluster/inventory.ini -e reset_confirmation=yes --become --become-user=root reset.yml
    RET=$?
    if [ "$RET" -ne 0 ]; then
      exit 1
    fi
  fi
  CLUSTER_CNT="$2"
  for i in $(seq 1 $CLUSTER_CNT); do
    ansible-playbook -i localhost, -c local -e mode=multi -e cluster_no=$i --become --become-user=root playbooks/local.yml
    RET=$?
    if [ "$RET" -ne 0 ]; then
      exit 1
    else
      ansible-playbook -i inventory/mycluster/inventory.ini -e reset_confirmation=yes --become --become-user=root reset.yml
      RET=$?
      if [ "$RET" -ne 0 ]; then
        exit 1
      fi
    fi
  done
fi
