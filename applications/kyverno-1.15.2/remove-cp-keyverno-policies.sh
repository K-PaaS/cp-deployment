#!/bin/bash

kubectl delete ClusterPolicy cp-default-namespace-policy
kubectl delete ClusterPolicy cp-add-rolebinding-policy
kubectl delete ClusterPolicy cp-cleanup-network-policy
kubectl delete ClusterPolicy cp-always-pull-images-policy

echo "cp-kyverno-policies delete is complete."
