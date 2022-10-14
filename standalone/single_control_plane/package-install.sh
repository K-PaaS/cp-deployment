#!/bin/bash

PIP3_INSTALL=$(dpkg -l | grep python3-pip | awk '{print $2}')

if [ "$PIP3_INSTALL" == "" ]; then
  sudo apt-get update
  sudo apt-get install -y python3-pip
fi

PIP3_PACKAGE_INSTALL=$(pip3 freeze | grep ruamel.yaml)

if [ "$PIP3_PACKAGE_INSTALL" == "" ]; then
  sudo pip3 install -r requirements.txt
fi
