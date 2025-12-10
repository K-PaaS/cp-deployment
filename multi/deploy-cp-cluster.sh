#!/bin/bash

CLUSTER_CNT=$(grep '^CLUSTER_CNT=' cp-cluster-vars.sh | cut -d'=' -f2)

# Convert env to yaml
../standalone/convert-env-to-yaml.sh cp-cluster-vars.sh ../standalone/inventory/mycluster/group_vars/all/cluster_multi.yml

# Deploy K-PaaS Container Platform (Multi Cluster)
cd ../standalone
./deploy-cp-cluster.sh multi $CLUSTER_CNT
