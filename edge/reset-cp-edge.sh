#!/bin/bash

# Convert env to yaml
../standalone/convert-env-to-yaml.sh ../single/cp-cluster-vars.sh ../single/cluster_single.yml
../standalone/convert-env-to-yaml.sh cp-edge-vars.sh edge.yml

# Remove K-PaaS Container Platform (Edge Cluster)
cd ../standalone
./reset-cp-edge.sh
