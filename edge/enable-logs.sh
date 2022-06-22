#!/bin/bash

export CLOUDCOREIPS="{MASTER_PUBLIC_IP}"

cd /etc/kubeedge

wget https://raw.githubusercontent.com/kubeedge/kubeedge/master/build/tools/certgen.sh

chmod +x certgen.sh

/etc/kubeedge/certgen.sh stream

iptables -t nat -A OUTPUT -p tcp --dport 10350 -j DNAT --to $CLOUDCOREIPS:10003

cd ~/paas-ta-container-platform-deployment/edge
