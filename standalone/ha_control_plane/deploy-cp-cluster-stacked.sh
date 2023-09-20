#!/bin/bash

# Registering Container Platform ENV
source cp-cluster-vars-stacked.sh

# Installing Ubuntu, PIP3 Package
PIP3_INSTALL=$(dpkg -l | grep python3-pip | awk '{print $2}')

if [ "$PIP3_INSTALL" == "" ]; then
  sudo apt-get update
  sudo apt-get install -y python3-pip
fi

PIP3_PACKAGE_INSTALL=$(pip3 freeze | grep ruamel.yaml)

if [ "$PIP3_PACKAGE_INSTALL" == "" ]; then
  sudo pip3 install -r requirements.txt
fi

# Container Platform configuration settings
rm -rf inventory/mycluster/hosts.yaml
cp inventory/mycluster/inventory.ini.ori inventory/mycluster/inventory.ini
cp roles/kubernetes-apps/metrics_server/defaults/main.yml.ori roles/kubernetes-apps/metrics_server/defaults/main.yml
cp roles/kubernetes/control-plane/tasks/kubeadm-setup.yml.ori roles/kubernetes/control-plane/tasks/kubeadm-setup.yml
cp roles/container-engine/cri-o/defaults/main.yml.ori roles/container-engine/cri-o/defaults/main.yml
cp inventory/mycluster/group_vars/all/all.yml.ori inventory/mycluster/group_vars/all/all.yml
cp ../applications/vault-1.11.3/payload.json.ori ../applications/vault-1.11.3/payload.json
cp roles/cp/vault/defaults/main.yml.ori roles/cp/vault/defaults/main.yml
cp ../applications/nfs-provisioner-4.0.0/deployment.yaml.ori ../applications/nfs-provisioner-4.0.0/deployment.yaml
cp roles/cp/storage/defaults/main.yml.ori roles/cp/storage/defaults/main.yml

for ((i=0;i<$WORKER_NODE_CNT;i++))
  do
    j=$((i+1));
    find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[kube_control_plane\]/i\{WORKER${j}_NODE_HOSTNAME} ansible_host={WORKER${j}_NODE_PRIVATE_IP} ip={WORKER${j}_NODE_PRIVATE_IP}" {} \;;
    find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[kube_node\]/a\{WORKER${j}_NODE_HOSTNAME}" {} \;;
done

sed -i "s/{MASTER1_NODE_HOSTNAME}/$MASTER1_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER1_NODE_PRIVATE_IP}/$MASTER1_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER2_NODE_HOSTNAME}/$MASTER2_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER2_NODE_PRIVATE_IP}/$MASTER2_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER3_NODE_HOSTNAME}/$MASTER3_NODE_HOSTNAME/g" inventory/mycluster/inventory.ini
sed -i "s/{MASTER3_NODE_PRIVATE_IP}/$MASTER3_NODE_PRIVATE_IP/g" inventory/mycluster/inventory.ini

ARRAY_WORKER_NODE_IP=""
ARRAY_BOUND_CIDRS=""

ARRAY_BOUND_CIDRS="\\\"${MASTER1_NODE_PRIVATE_IP}/32\\\", \\\"${MASTER2_NODE_PRIVATE_IP}/32\\\", \\\"${MASTER3_NODE_PRIVATE_IP}/32\\\"";

for ((i=0;i<$WORKER_NODE_CNT;i++))
  do
    j=$((i+1));
    eval "worker_node_hostname=\${WORKER${j}_NODE_HOSTNAME}";
    eval "worker_node_private_ip=\${WORKER${j}_NODE_PRIVATE_IP}";
    ARRAY_WORKER_NODE_IP="${ARRAY_WORKER_NODE_IP} ${worker_node_private_ip}";
    ARRAY_BOUND_CIDRS="${ARRAY_BOUND_CIDRS}, \\\"${worker_node_private_ip}/32\\\"";
    sed -i "s/{WORKER"$j"_NODE_HOSTNAME}/$worker_node_hostname/g" inventory/mycluster/inventory.ini;
    sed -i "s/{WORKER"$j"_NODE_PRIVATE_IP}/$worker_node_private_ip/g" inventory/mycluster/inventory.ini;
done

sed -i "s/{MASTER_NODE_HOSTNAME}/$MASTER1_NODE_HOSTNAME/g" roles/kubernetes-apps/metrics_server/defaults/main.yml

sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER1_NODE_PUBLIC_IP/g" roles/kubernetes/control-plane/tasks/kubeadm-setup.yml
sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER1_NODE_PUBLIC_IP/g" roles/container-engine/cri-o/defaults/main.yml

sed -i "s/{LOADBALANCER_DOMAIN}/$LOADBALANCER_DOMAIN/g" inventory/mycluster/group_vars/all/all.yml
sed -i "s/{ETCD1_NODE_PRIVATE_IP}/$MASTER1_NODE_PRIVATE_IP/g" inventory/mycluster/group_vars/all/all.yml
sed -i "s/{ETCD2_NODE_PRIVATE_IP}/$MASTER2_NODE_PRIVATE_IP/g" inventory/mycluster/group_vars/all/all.yml
sed -i "s/{ETCD3_NODE_PRIVATE_IP}/$MASTER3_NODE_PRIVATE_IP/g" inventory/mycluster/group_vars/all/all.yml

sed -i "s@{BOUND_CIDRS}@$ARRAY_BOUND_CIDRS@g" ../applications/vault-1.11.3/payload.json

sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER1_NODE_PUBLIC_IP/g" roles/cp/vault/defaults/main.yml

sed -i "s/{NFS_SERVER_PRIVATE_IP}/$NFS_SERVER_PRIVATE_IP/g" ../applications/nfs-provisioner-4.0.0/deployment.yaml

sed -i "s/{STORAGE_TYPE}/$STORAGE_TYPE/g" roles/cp/storage/defaults/main.yml

declare -a IPS=($MASTER1_NODE_PRIVATE_IP $MASTER2_NODE_PRIVATE_IP $MASTER3_NODE_PRIVATE_IP $ARRAY_WORKER_NODE_IP)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Deploy Container Platform
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
