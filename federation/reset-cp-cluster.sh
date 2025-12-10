#!/bin/bash

CLUSTER_CNT=$(grep '^CLUSTER_CNT=' member-cp-cluster-vars.sh | cut -d'=' -f2)

# Convert env to yaml
../standalone/convert-env-to-yaml.sh host-cp-cluster-vars.sh ../single/cluster_single.yml
../standalone/convert-env-to-yaml.sh member-cp-cluster-vars.sh ../multi/cluster_multi.yml

# Remove Container Platform (Federation Cluster)
cd ../standalone
./reset-cp-cluster.sh federation $CLUSTER_CNT
