#!/bin/bash

############################################################################################
# 0. patch clusterrole : Add 'update' role to namespace (origin : get,list,watch)          #
############################################################################################
kubectl patch clusterrole kyverno:background-controller:core --type='json' -p='[{"op": "replace", "path": "/rules/2", "value":{ "apiGroups": [""], "resources": ["namespaces","configmaps"], "verbs": ["get","list","watch","update"]}}]'


############################################################################################
# 1.네임스페이스 정책 생성 및 배포 (If Namespace is created then NetworkPolicy is create.)  #
############################################################################################

## Add nodes IPv4VXLANTunnelAddr
echo "            # You must find the vxlan.calico IP through the ifconfig command on the Master Node." > IPv4VXLANTunnelAddr.yaml

for IPv4VXLANTunnelAddr in `route -n | grep -e '*' -e 'vxlan.calico' | cut -d ' ' -f 1`
do
echo "            - ipBlock:" >> IPv4VXLANTunnelAddr.yaml
echo "                cidr: ${IPv4VXLANTunnelAddr}/32" >> IPv4VXLANTunnelAddr.yaml
done

IPv4VXLANTunnelAddrYaml=`cat IPv4VXLANTunnelAddr.yaml`

cat << EOF > cp-default-namespace-policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: cp-default-namespace-policy
spec:
  rules:
  - name: cp-default-namespace-rule
    match:
      any:
      - resources:
          kinds:
          - Namespace
    exclude:
      any:
      - resources:
          namespaces:
          - ingress-nginx
          - istio-system
          - metallb-system
          - kubeedge
          - kubeflow
          - kubeflow-user-example-com
          - knative-eventing
          - knative-serving
          - auth
          - cert-manager
          - keycloak
          - harbor
          - vault
          - mariadb
          - cp-portal
          - cp-pipeline
          - cp-source-control
          - chaos-mesh
          - chartmuseum
          - postgres
    generate:
      apiVersion: networking.k8s.io/v1
      kind: NetworkPolicy
      name: cp-default-namespace-policy
      namespace: "{{request.object.metadata.name}}"
      synchronize: true
      data:
        spec:
          ingress:
          - from:
            - namespaceSelector:
                matchLabels:
                  kubernetes.io/metadata.name: "{{request.object.metadata.name}}"
            - namespaceSelector:
                matchLabels:
                  kubernetes.io/metadata.name: kube-system
            - namespaceSelector:
                matchLabels:
                  kubernetes.io/metadata.name: metallb-system
            - namespaceSelector:
                matchLabels:
                  kubernetes.io/metadata.name: istio-system
            - namespaceSelector:
                matchLabels:
                  kubernetes.io/metadata.name: ingress-nginx
            - namespaceSelector:
                matchLabels:
                  kubernetes.io/metadata.name: cp-portal
            - namespaceSelector:
                matchLabels:
                  kubernetes.io/metadata.name: chaos-mesh
            - ipBlock:
                cidr: 0.0.0.0/0
                except:
                - 10.233.64.0/18
${IPv4VXLANTunnelAddrYaml}
            - podSelector: {}
          podSelector: {}
          policyTypes:
          - Ingress
  - name: cp-default-pod-shared-rule
    match:
      any:
      - resources:
          kinds:
          - Namespace
    exclude:
      any:
      - resources:
          namespaces:
          - ingress-nginx
          - istio-system
          - metallb-system
          - kubeedge
          - kubeflow
          - kubeflow-user-example-com
          - knative-eventing
          - knative-serving
          - auth
          - cert-manager
          - keycloak
          - harbor
          - vault
          - mariadb
          - cp-portal
          - cp-pipeline
          - cp-source-control
          - chaos-mesh
          - chartmuseum
          - postgres
    generate:
      apiVersion: networking.k8s.io/v1
      kind: NetworkPolicy
      name: cp-default-pod-shared-policy
      namespace: "{{request.object.metadata.name}}"
      synchronize: true
      data:
        spec:
          ingress:
          - from:
            - ipBlock:
                cidr: 10.233.64.0/18
          podSelector:
            matchLabels:
              cp-role: shared
          policyTypes:
          - Ingress
EOF

kubectl apply -f cp-default-namespace-policy.yaml

########################################################################################################################
# 2.롤바인딩 정책 생성 및 배포 (If RoleBinding is created then NetworkPolicy is create and Namespace label is update.)   #
########################################################################################################################

cat << EOF > cp-add-rolebinding-policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: cp-add-rolebinding-policy
spec:
  rules:
  - name: cp-default-namespace-create-rule
    match:
      any:
      - resources:
          kinds:
          - RoleBinding
    exclude:
      any:
      - resources:
          namespaces:
          - ingress-nginx
          - istio-system
          - metallb-system
          - kubeedge
          - kubeflow
          - kubeflow-user-example-com
          - knative-eventing
          - knative-serving
          - auth
          - cert-manager
          - keycloak
          - harbor
          - vault
          - mariadb
          - cp-portal
          - cp-pipeline
          - cp-source-control
          - chaos-mesh
          - chartmuseum
          - postgres
    mutate:
      targets:
        - apiVersion: v1
          kind: Namespace
          name: "{{ request.object.metadata.namespace }}"
      patchStrategicMerge:
        metadata:
          labels:
            +({{ request.object.metadata.name }}): "true"
  - name: cp-default-namespace-update-rule
    match:
      any:
      - resources:
          kinds:
          - RoleBinding
    exclude:
      any:
      - resources:
          namespaces:
          - ingress-nginx
          - istio-system
          - metallb-system
          - kubeedge
          - kubeflow
          - kubeflow-user-example-com
          - knative-eventing
          - knative-serving
          - auth
          - cert-manager
          - keycloak
          - harbor
          - vault
          - mariadb
          - cp-portal
          - cp-pipeline
          - cp-source-control
          - chaos-mesh
          - chartmuseum
          - postgres
    mutate:
      targets:
        - apiVersion: v1
          kind: Namespace
          name: "{{ request.object.metadata.namespace }}"
      patchStrategicMerge:
        metadata:
          labels:
            "{{ request.object.metadata.name }}": "true"
  - name: cp-default-networkpolicy-create-rule
    match:
      any:
      - resources:
          kinds:
          - RoleBinding
    exclude:
      any:
      - resources:
          namespaces:
          - ingress-nginx
          - istio-system
          - metallb-system
          - kubeedge
          - kubeflow
          - kubeflow-user-example-com
          - knative-eventing
          - knative-serving
          - auth
          - cert-manager
          - keycloak
          - harbor
          - vault
          - mariadb
          - cp-portal
          - cp-pipeline
          - cp-source-control
          - chaos-mesh
          - chartmuseum
          - postgres
    generate:
      apiVersion: networking.k8s.io/v1
      kind: NetworkPolicy
      name: "{{ request.object.metadata.name }}"
      namespace: "{{request.object.metadata.namespace}}"
      synchronize: true
      data:
        spec:
          podSelector: {}
          ingress:
          - from:
            - namespaceSelector:
                matchLabels:
                  "{{ request.object.metadata.name }}": "true"
          policyTypes:
          - Ingress
EOF
kubectl apply -f cp-add-rolebinding-policy.yaml

#####################################################################################################
# 3.롤바인딩 cleanup 정책 생성 및 배포  (If RoleBinding is deleted then Namespace lable is update.)   #
#####################################################################################################

cat << EOF > cp-cleanup-network-policy.yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: cp-cleanup-network-policy
spec:
  rules:
  - name: cp-cleanup-network-policy-rule
    match:
      any:
      - resources:
          kinds:
          - RoleBinding
          operations:
          - DELETE
    exclude:
      any:
      - resources:
          namespaces:
          - ingress-nginx
          - istio-system
          - metallb-system
          - kubeedge
          - kubeflow
          - kubeflow-user-example-com
          - knative-eventing
          - knative-serving
          - auth
          - cert-manager
          - keycloak
          - harbor
          - vault
          - mariadb
          - cp-portal
          - cp-pipeline
          - cp-source-control
          - chaos-mesh
          - chartmuseum
          - postgres
    mutate:
      targets:
        - apiVersion: v1
          kind: Namespace
          name: "{{ request.object.metadata.namespace }}"
      patchStrategicMerge:
        metadata:
          labels:
            "{{ request.object.metadata.name }}": "false"
EOF
kubectl apply -f cp-cleanup-network-policy.yaml


# delete yaml
rm IPv4VXLANTunnelAddr.yaml
rm cp-default-namespace-policy.yaml
rm cp-add-rolebinding-policy.yaml
rm cp-cleanup-network-policy.yaml

echo "cp-kyverno-policies deployment is complete."

