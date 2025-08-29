#!/bin/bash

export CLUSTER_CNT=2

for IDX in $(seq 1 "$CLUSTER_CNT"); do
if [[ IDX -eq 1 ]]; then
cat <<EOF > cp-cluster-vars.sh
#!/bin/bash

export CLUSTER_CNT=${CLUSTER_CNT}
EOF
fi

cat <<EOF >> cp-cluster-vars.sh

#################################
# CLUSTER${IDX}
#################################

# Master Node Count Variable (eg. 1, 3, 5 ...)
export CLUSTER${IDX}_KUBE_CONTROL_HOSTS=

# if KUBE_CONTROL_HOSTS > 1 (eg. external, stacked)
export CLUSTER${IDX}_ETCD_TYPE=

# if KUBE_CONTROL_HOSTS > 1
# HA Control Plane LoadBalanncer IP or Domain
export CLUSTER${IDX}_LOADBALANCER_DOMAIN=

# if ETCD_TYPE=external
# The number of ETCD node variable is set equal to the number of KUBE_CONTROL_HOSTS
export CLUSTER${IDX}_ETCD1_NODE_HOSTNAME=
export CLUSTER${IDX}_ETCD1_NODE_PRIVATE_IP=
export CLUSTER${IDX}_ETCD2_NODE_HOSTNAME=
export CLUSTER${IDX}_ETCD2_NODE_PRIVATE_IP=
export CLUSTER${IDX}_ETCD3_NODE_HOSTNAME=
export CLUSTER${IDX}_ETCD3_NODE_PRIVATE_IP=

# Master Node Info Variable
# The number of MASTER node variable is set equal to the number of KUBE_CONTROL_HOSTS
export CLUSTER${IDX}_MASTER1_NODE_HOSTNAME=
export CLUSTER${IDX}_MASTER1_NODE_PUBLIC_IP=
export CLUSTER${IDX}_MASTER1_NODE_PRIVATE_IP=
export CLUSTER${IDX}_MASTER2_NODE_HOSTNAME=
export CLUSTER${IDX}_MASTER2_NODE_PRIVATE_IP=
export CLUSTER${IDX}_MASTER3_NODE_HOSTNAME=
export CLUSTER${IDX}_MASTER3_NODE_PRIVATE_IP=

# Worker Node Count Variable
export CLUSTER${IDX}_KUBE_WORKER_HOSTS=

# Worker Node Info Variable
# The number of Worker node variable is set equal to the number of KUBE_WORKER_HOSTS
export CLUSTER${IDX}_WORKER1_NODE_HOSTNAME=
export CLUSTER${IDX}_WORKER1_NODE_PRIVATE_IP=
export CLUSTER${IDX}_WORKER2_NODE_HOSTNAME=
export CLUSTER${IDX}_WORKER2_NODE_PRIVATE_IP=
export CLUSTER${IDX}_WORKER3_NODE_HOSTNAME=
export CLUSTER${IDX}_WORKER3_NODE_PRIVATE_IP=

# Storage Variable (eg. nfs, rook-ceph)
export CLUSTER${IDX}_STORAGE_TYPE=

# if STORATE_TYPE=nfs
export CLUSTER${IDX}_NFS_SERVER_PRIVATE_IP=

# MetalLB Variable (eg. 192.168.0.150-192.168.0.160)
export CLUSTER${IDX}_METALLB_IP_RANGE=

# MetalLB Ingress Nginx Controller LoadBalancer Service External IP
export CLUSTER${IDX}_INGRESS_NGINX_IP=

# MetalLB Istio Gateway LoadBalancer Service External IP
export CLUSTER${IDX}_ISTIO_GATEWAY_PRIVATE_IP=
export CLUSTER${IDX}_ISTIO_GATEWAY_PUBLIC_IP=

# Enter only if the CSP is NHN Cloud (eg. NHN)
export CLUSTER_CSP_TYPE=

# if CSP_TYPE=NHN
export CLUSTER${IDX}_NHN_USERNAME=
export CLUSTER${IDX}_NHN_PASSWORD=
export CLUSTER${IDX}_NHN_TENANT_ID=
export CLUSTER${IDX}_NHN_VIP_SUBNET_ID=
EOF
done

cat <<EOF > cluster.yml
---
EOF

for IDX in $(seq 1 "$CLUSTER_CNT"); do

IDX2=$((IDX-1));

cat <<EOF >> cluster.yml
- hosts: kube_control_plane[${IDX2}]
  gather_facts: False
  any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
  roles:
    - { role: cp-download }

- hosts: kube_control_plane[${IDX2}]
  gather_facts: False
  any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
  roles:
    - { role: cp-setting }

- hosts: kube_control_plane[${IDX2}]
  gather_facts: False
  any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
  roles:
    - { role: cp-install }

- hosts: kube_control_plane[${IDX2}]
  gather_facts: False
  any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
  roles:
    - { role: kubeconfig }

EOF
done

cat <<EOF >> cluster.yml
- hosts: localhost
  gather_facts: False
  any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
  roles:
    - { role: kubectl }

- hosts: localhost
  gather_facts: False
  any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
  roles:
    - { role: kubeconfig-merge }

- hosts: localhost
  gather_facts: False
  any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
  roles:
    - { role: helm }

- hosts: localhost
  gather_facts: False
  any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
  roles:
    - { role: podman }

- hosts: localhost
  gather_facts: False
  any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
  roles:
    - { role: istio }

- hosts: localhost
  gather_facts: False
  any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
  roles:
    - { role: istio-multi }
EOF
