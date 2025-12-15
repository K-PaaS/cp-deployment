#!/bin/bash

sudo chmod o+w /tmp
sudo chmod o+w /var/tmp

# Convert env to yaml
../standalone/convert-env-to-yaml.sh ../single/cp-cluster-vars.sh ../single/cluster_single.yml
../standalone/convert-env-to-yaml.sh cp-edge-vars.sh edge.yml

# Deploy K-PaaS Container Platform (Edge Cluster)
cd ../standalone
./deploy-cp-edge.sh
