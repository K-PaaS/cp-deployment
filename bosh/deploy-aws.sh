#!/bin/bash

# SET VARIABLES
export CONTAINER_DEPLOYMENT_NAME='paasta-container-platform'
export CONTAINER_BOSH2_NAME='micro-bosh'
export CONTAINER_BOSH2_UUID=`bosh int <(bosh -e ${CONTAINER_BOSH2_NAME} environment --json) --path=/Tables/0/Rows/0/uuid`

# DEPLOY
bosh -e ${CONTAINER_BOSH2_NAME} -n -d ${CONTAINER_DEPLOYMENT_NAME} deploy --no-redact manifests/paasta-container-service-deployment-aws.yml \
    -l manifests/paasta-container-service-vars-aws.yml \
    -o manifests/ops-files/paasta-container-service/network-aws.yml \
    -o manifests/ops-files/misc/first-time-deploy.yml \
    -o manifests/ops-files/add-jenkins-service-broker.yml \
    -o manifests/ops-files/add-service-broker.yml \
    -v deployment_name=${CONTAINER_DEPLOYMENT_NAME} \
    -v director_name=${CONTAINER_BOSH2_NAME} \
    -v director_uuid=${CONTAINER_BOSH2_UUID}
