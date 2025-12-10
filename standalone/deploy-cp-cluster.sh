#!/bin/bash

MODE="$1"

# Installing Ubuntu, PIP3 Package
PIP3_INSTALL=$(dpkg -l | grep python3-pip | awk '{print $2}')
OS_VERSION=$(cat /etc/lsb-release | grep DISTRIB_RELEASE | awk -F '=' '{print $2}')

if [ "$PIP3_INSTALL" == "" ]; then
  sudo apt-get update
  if [ "$OS_VERSION" == "22.04" ]; then
    sudo apt-get install -y python3-pip
  elif [ "$OS_VERSION" == "24.04" ]; then
    sudo apt-get install -y python3-pip python3-venv
  fi
  echo "pip3 installation completed."
fi

PIP3_PACKAGE_INSTALL=$(pip3 freeze | grep ansible)

if [ "$PIP3_PACKAGE_INSTALL" == "" ]; then
  if [ "$OS_VERSION" == "24.04" ]; then
    python3 -m venv ~/kpaas-venv
    source ~/kpaas-venv/bin/activate
  fi
  pip3 install -r requirements.txt

  echo "Python packages installation completed."
fi

NET_TOOLS_INSTALL=$(dpkg -l | grep net-tools | awk '{print $2}')

if [ "$NET_TOOLS_INSTALL" == "" ]; then
  sudo apt-get install -y net-tools
  echo "net-tools installation completed."
fi

JQ_INSTALL=$(dpkg -l | grep -w jq | awk '{print $2}')

if [ "$JQ_INSTALL" == "" ]; then
  sudo apt-get install -y jq
  echo "jq installation completed."
fi

export PATH=$PATH:$HOME/.local/bin
source $HOME/.bashrc

if [ "$MODE" == "single" ]; then
  ansible-playbook -i localhost, -c local -e mode=single playbooks/local.yml
  PRE_RET=$?
  if [ $PRE_RET -ne 0 ]; then
    exit 1
  else
    ansible-playbook -i inventory/mycluster/inventory.ini -e mode=single --become --become-user=root playbooks/cluster.yml
    POST_RET=$?
    if [ $POST_RET -ne 0 ]; then
      exit 1
    else
      ansible-playbook -i inventory/mycluster/inventory.ini --become --become-user=root playbooks/single.yml
    fi
  fi


elif [ "$MODE" == "multi" ]; then
  CLUSTER_CNT="$2"
  for i in $(seq 1 $CLUSTER_CNT); do
    ansible-playbook -i localhost, -c local -e mode=multi -e cluster_no=$i playbooks/local.yml
    PRE_RET=$?
    if [ $PRE_RET -ne 0 ]; then
      exit 1
    else
      ansible-playbook -i inventory/mycluster/inventory.ini -e mode=multi -e cluster_no=$i --become --become-user=root playbooks/cluster.yml
    fi
  done
  POST_RET=$?
  if [ $POST_RET -ne 0 ]; then
    exit 1
  else
    ansible-playbook -i inventory/mycluster/inventory.ini -e cluster_cnt=$CLUSTER_CNT --become --become-user=root playbooks/multi.yml
  fi



elif [ "$MODE" == "federation" ]; then
  ansible-playbook -i localhost, -c local -e mode=single playbooks/local.yml
  PRE_RET=$?
  if [ $PRE_RET -ne 0 ]; then
    exit 1
  else
    ansible-playbook -i inventory/mycluster/inventory.ini -e mode=single --become --become-user=root playbooks/cluster.yml
    POST_RET=$?
    if [ $POST_RET -ne 0 ]; then
      exit 1
    else
      ansible-playbook -i inventory/mycluster/inventory.ini --become --become-user=root playbooks/single.yml
    fi
  fi
  
  CLUSTER_CNT="$2"
  for i in $(seq 1 $CLUSTER_CNT); do
    ansible-playbook -i localhost, -c local -e mode=multi -e cluster_no=$i playbooks/local.yml
    PRE_RET=$?
    if [ $PRE_RET -ne 0 ]; then
      exit 1
    else
      ansible-playbook -i inventory/mycluster/inventory.ini -e mode=multi -e cluster_no=$i --become --become-user=root playbooks/cluster.yml
    fi
  done
  POST_RET=$?
  if [ $POST_RET -ne 0 ]; then
    exit 1
  else
    ansible-playbook -i inventory/mycluster/inventory.ini -e cluster_cnt=$CLUSTER_CNT --become --become-user=root playbooks/multi.yml
  fi
  POST_RET=$?
  if [ $POST_RET -ne 0 ]; then
    exit 1
  else
    ansible-playbook -i inventory/mycluster/inventory.ini -e cluster_cnt=$CLUSTER_CNT --become --become-user=root playbooks/federation.yml
  fi
fi
