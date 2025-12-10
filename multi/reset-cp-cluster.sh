#!/bin/bash

CLUSTER_CNT=$(grep '^CLUSTER_CNT=' cp-cluster-vars.sh | cut -d'=' -f2)

# Convert env to yaml
../standalone/convert-env-to-yaml.sh cp-cluster-vars.sh cluster_multi.yml

# Remove Container Platform (Multi Cluster)
cd ../standalone
./reset-cp-cluster.sh multi $CLUSTER_CNT
