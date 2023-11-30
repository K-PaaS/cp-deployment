#!/bin/bash

# Master Node Count Variable (eg. 1, 3, 5 ...)
export KUBE_CONTROL_HOSTS=

# if KUBE_CONTROL_HOSTS > 1 (eg. external, stacked)
export ETCD_TYPE=

# if KUBE_CONTROL_HOSTS > 1
# HA Control Plane LoadBalanncer IP or Domain
export LOADBALANCER_DOMAIN=

# if ETCD_TYPE=external
# The number of ETCD node variable is set equal to the number of KUBE_CONTROL_HOSTS
export ETCD1_NODE_HOSTNAME=
export ETCD1_NODE_PRIVATE_IP=
export ETCD2_NODE_HOSTNAME=
export ETCD2_NODE_PRIVATE_IP=
export ETCD3_NODE_HOSTNAME=
export ETCD3_NODE_PRIVATE_IP=

# Master Node Info Variable
# The number of MASTER node variable is set equal to the number of KUBE_CONTROL_HOSTS
export MASTER1_NODE_HOSTNAME=
export MASTER1_NODE_PUBLIC_IP=
export MASTER1_NODE_PRIVATE_IP=
export MASTER2_NODE_HOSTNAME=
export MASTER2_NODE_PRIVATE_IP=
export MASTER3_NODE_HOSTNAME=
export MASTER3_NODE_PRIVATE_IP=

# Worker Node Count Variable
export KUBE_WORKER_HOSTS=

# Worker Node Info Variable
# The number of Worker node variable is set equal to the number of KUBE_WORKER_HOSTS
export WORKER1_NODE_HOSTNAME=
export WORKER1_NODE_PRIVATE_IP=
export WORKER2_NODE_HOSTNAME=
export WORKER2_NODE_PRIVATE_IP=
export WORKER3_NODE_HOSTNAME=
export WORKER3_NODE_PRIVATE_IP=

# Storage Variable (eg. nfs, rook-ceph)
export STORAGE_TYPE=

# if STORATE_TYPE=nfs
export NFS_SERVER_PRIVATE_IP=

# MetalLB Variable (eg. 192.168.0.150-192.168.0.160)
export METALLB_IP_RANGE=

# MetalLB Ingress Nginx Controller LoadBalancer Service External IP
export INGRESS_NGINX_PRIVATE_IP=
