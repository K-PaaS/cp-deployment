#!/bin/bash

kubectl patch clusterrole kyverno:background-controller:core --type='json' -p='[{"op": "replace", "path": "/rules/2", "value":{ "apiGroups": [""], "resources": ["namespaces","configmaps"], "verbs": ["get","list","watch"]}}]'

kubectl delete ClusterPolicy cp-default-namespace-policy
kubectl delete ClusterPolicy cp-add-rolebinding-policy
kubectl delete ClusterPolicy cp-cleanup-network-policy

echo "cp-kyverno-policies delete is complete."