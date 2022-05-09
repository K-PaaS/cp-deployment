#!/bin/bash

for ((i=0;i<$EDGE_NODE_CNT;i++))
  do
    j=$((i+1));
    eval "edge_node_hostname=\${EDGE${j}_NODE_HOSTNAME}";
    eval "edge_node_private_ip=\${EDGE${j}_NODE_PRIVATE_IP}";

    find inventory/mycluster/hosts.yaml -exec sed -i -r -e "/children:/i\    $edge_node_hostname:\n      ansible_host: $edge_node_private_ip\n      ip: $edge_node_private_ip\n      access_ip: $edge_node_private_ip" {} \;
    find inventory/mycluster/hosts.yaml -exec sed -i -r -e "etcd:/i\    edge_node:\n      hosts:\n        $edge_node_hostname:" {} \;
done

sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER_NODE_PUBLIC_IP/g" roles/paasta-cp/edge/keadm_init/defaults/main.yml
sed -i "s/{MASTER_NODE_PRIVATE_IP}/$MASTER_NODE_PRIVATE_IP/g" roles/paasta-cp/edge/keadm_init/defaults/main.yml

sed -i "s/{MASTER_NODE_PUBLIC_IP}/$MASTER_NODE_PUBLIC_IP/g" roles/paasta-cp/edge/keadm_join/defaults/main.yml
