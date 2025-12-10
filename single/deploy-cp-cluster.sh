#!/bin/bash

# Convert env to yaml
../standalone/convert-env-to-yaml.sh cp-cluster-vars.sh cluster_single.yml

# Deploy K-PaaS Container Platform (Single Cluster)
cd ../standalone
./deploy-cp-cluster.sh single
