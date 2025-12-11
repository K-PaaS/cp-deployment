#!/bin/bash

# Convert env to yaml
../standalone/convert-env-to-yaml.sh cp-cluster-vars.sh cluster_single.yml

# Remove K-PaaS Container Platform (Single Cluster)
cd ../standalone
./reset-cp-cluster.sh single
