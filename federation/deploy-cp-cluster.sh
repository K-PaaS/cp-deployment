#!/bin/bash

CLUSTER_CNT=$(grep '^CLUSTER_CNT=' member-cp-cluster-vars.sh | cut -d'=' -f2)

# Convert env to yaml
../standalone/convert-env-to-yaml.sh host-cp-cluster-vars.sh ../standalone/inventory/mycluster/group_vars/all/cluster_single.yml
../standalone/convert-env-to-yaml.sh member-cp-cluster-vars.sh ../standalone/inventory/mycluster/group_vars/all/cluster_multi.yml

# Deploy K-PaaS Container Platform (Federation Cluster)
cd ../standalone
./deploy-cp-cluster.sh federation $CLUSTER_CNT
