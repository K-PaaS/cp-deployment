#!/bin/bash

CLUSTER_CNT=2

cat <<EOF > host-cp-cluster-vars.sh
#!/bin/bash

######################################################################
# HOST CLUSTER
######################################################################

# --------------------------------------------------------------------
# Control Plane 노드 설정
# --------------------------------------------------------------------

# Control Plane (Master) 노드 개수 (예: 1, 3, 5 ...)
KUBE_CONTROL_HOSTS=

# Control Plane (Master) 노드 정보
# Control Plane 노드 개수에 맞춰 설정
MASTER1_NODE_HOSTNAME=
MASTER1_NODE_USER=ubuntu
MASTER1_NODE_PRIVATE_IP=
MASTER1_NODE_PUBLIC_IP=
MASTER2_NODE_HOSTNAME=
MASTER2_NODE_PRIVATE_IP=
MASTER3_NODE_HOSTNAME=
MASTER3_NODE_PRIVATE_IP=

# --------------------------------------------------------------------
# LoadBalancer 설정
# --------------------------------------------------------------------

# Control Plane 노드가 2개 이상일 때 필수 설정
# 외부 로드밸런서 도메인 또는 IP
LOADBALANCER_DOMAIN=

# --------------------------------------------------------------------
# ETCD 노드 설정
# --------------------------------------------------------------------

# ETCD 구성 방식
# Control Plane 노드가 2개 이상일 때 필수 설정 (예: external, stacked)
# - external : 별도 ETCD 노드 구성
# - stacked : Control Plane 노드에 ETCD가 통합된 구성
ETCD_TYPE=

# ETCD_TYPE=external 일 때 필수 설정
# Control Plane 노드 수와 동일 개수로 설정
ETCD1_NODE_HOSTNAME=
ETCD1_NODE_PRIVATE_IP=
ETCD2_NODE_HOSTNAME=
ETCD2_NODE_PRIVATE_IP=
ETCD3_NODE_HOSTNAME=
ETCD3_NODE_PRIVATE_IP=

# --------------------------------------------------------------------
# Worker 노드 설정
# --------------------------------------------------------------------

# Worker 노드 개수
KUBE_WORKER_HOSTS=

# Worker 노드 정보
# Worker 노드 개수에 맞춰 설정
WORKER1_NODE_HOSTNAME=
WORKER1_NODE_PRIVATE_IP=
WORKER2_NODE_HOSTNAME=
WORKER2_NODE_PRIVATE_IP=
WORKER3_NODE_HOSTNAME=
WORKER3_NODE_PRIVATE_IP=

# --------------------------------------------------------------------
# Storage 설정
# --------------------------------------------------------------------

# Storage 구성 방식 (예: nfs, rook-ceph)
STORAGE_TYPE=

# Storage 구성 방식 'nfs'일 때 NFS 서버 Private IP
NFS_SERVER_PRIVATE_IP=

# --------------------------------------------------------------------
# MetalLB 설정
# --------------------------------------------------------------------

# MetalLB Address Pool 범위 (예: 192.168.0.150-192.168.0.160)
METALLB_IP_RANGE=

# Ingress Nginx Controller LoadBalancer Service용 External IP
# - 인터페이스 추가 방식 : 인터페이스 Private IP 입력
# - LoadBalance 서비스 방식 : LoadBalance 서비스 Public IP 입력
INGRESS_NGINX_IP=

# --------------------------------------------------------------------
# Kyverno 설정
# --------------------------------------------------------------------

# Kyverno 설치 여부 (예: Y, N)
# - Y : 설치, PSS (Pod Security Standards) 및 cp-policy 정책 (네임스페이스간 네트워크 격리) 자동 적용
# - N : 설치하지 않음
INSTALL_KYVERNO=

# --------------------------------------------------------------------
# CSP LoadBalancer Controller 설정
# --------------------------------------------------------------------

# CSP 설정 (예: NHN, NAVER)
CSP_TYPE=

# NHN Cloud 환경 변수 (CSP_TYPE=NHN 일때 필수 입력)
NHN_USERNAME=
NHN_PASSWORD=
NHN_TENANT_ID=
NHN_VIP_SUBNET_ID=
NHN_API_BASE_URL=https://kr1-api-network-infrastructure.nhncloudservice.com

# NAVER Cloud 환경 변수 (CSP_TYPE=NAVER 일때 필수 입력)
NAVER_CLOUD_API_KEY=
NAVER_CLOUD_API_SECRET=
NAVER_CLOUD_REGION=KR
NAVER_CLOUD_VPC_NO=
NAVER_CLOUD_SUBNET_NO=
EOF

for IDX in $(seq 1 "$CLUSTER_CNT"); do
if [[ IDX -eq 1 ]]; then
cat <<EOF > member-cp-cluster-vars.sh
#!/bin/bash

CLUSTER_CNT=${CLUSTER_CNT}
EOF
fi

cat <<EOF >> member-cp-cluster-vars.sh

######################################################################
# MEMBER CLUSTER${IDX}
######################################################################

# --------------------------------------------------------------------
# Control Plane 노드 설정
# --------------------------------------------------------------------

# Control Plane (Master) 노드 개수 (예: 1, 3, 5 ...)
CLUSTER${IDX}_KUBE_CONTROL_HOSTS=

# Control Plane (Master) 노드 정보
# Control Plane 노드 개수에 맞춰 설정
CLUSTER${IDX}_MASTER1_NODE_HOSTNAME=
CLUSTER${IDX}_MASTER1_NODE_PUBLIC_IP=
CLUSTER${IDX}_MASTER1_NODE_PRIVATE_IP=
CLUSTER${IDX}_MASTER2_NODE_HOSTNAME=
CLUSTER${IDX}_MASTER2_NODE_PRIVATE_IP=
CLUSTER${IDX}_MASTER3_NODE_HOSTNAME=
CLUSTER${IDX}_MASTER3_NODE_PRIVATE_IP=

# --------------------------------------------------------------------
# LoadBalancer 설정
# --------------------------------------------------------------------

# Control Plane 노드가 2개 이상일 때 필수 설정
# 외부 로드밸런서 도메인 또는 IP
CLUSTER${IDX}_LOADBALANCER_DOMAIN=

# --------------------------------------------------------------------
# ETCD 노드 설정
# --------------------------------------------------------------------

# ETCD 구성 방식
# Control Plane 노드가 2개 이상일 때 필수 설정 (예: external, stacked)
# - external : 별도 ETCD 노드 구성
# - stacked : Control Plane 노드에 ETCD가 통합된 구성
CLUSTER${IDX}_ETCD_TYPE=

# ETCD_TYPE=external 일 때 필수 설정
# Control Plane 노드 수와 동일 개수로 설정
CLUSTER${IDX}_ETCD1_NODE_HOSTNAME=
CLUSTER${IDX}_ETCD1_NODE_PRIVATE_IP=
CLUSTER${IDX}_ETCD2_NODE_HOSTNAME=
CLUSTER${IDX}_ETCD2_NODE_PRIVATE_IP=
CLUSTER${IDX}_ETCD3_NODE_HOSTNAME=
CLUSTER${IDX}_ETCD3_NODE_PRIVATE_IP=

# --------------------------------------------------------------------
# Worker 노드 설정
# --------------------------------------------------------------------

# Worker 노드 개수
CLUSTER${IDX}_KUBE_WORKER_HOSTS=

# Worker 노드 정보
# Worker 노드 개수에 맞춰 설정
CLUSTER${IDX}_WORKER1_NODE_HOSTNAME=
CLUSTER${IDX}_WORKER1_NODE_PRIVATE_IP=
CLUSTER${IDX}_WORKER2_NODE_HOSTNAME=
CLUSTER${IDX}_WORKER2_NODE_PRIVATE_IP=
CLUSTER${IDX}_WORKER3_NODE_HOSTNAME=
CLUSTER${IDX}_WORKER3_NODE_PRIVATE_IP=

# --------------------------------------------------------------------
# Storage 설정
# --------------------------------------------------------------------

# Storage 구성 방식 (예: nfs, rook-ceph)
CLUSTER${IDX}_STORAGE_TYPE=

# Storage 구성 방식 'nfs'일 때 NFS 서버 Private IP
CLUSTER${IDX}_NFS_SERVER_PRIVATE_IP=

# --------------------------------------------------------------------
# MetalLB 설정
# --------------------------------------------------------------------

# MetalLB Address Pool 범위 (예: 192.168.0.150-192.168.0.160)
CLUSTER${IDX}_METALLB_IP_RANGE=

# Ingress Nginx Controller LoadBalancer Service용 External IP
# - 인터페이스 추가 방식 : 인터페이스 Private IP 입력
# - LoadBalance 서비스 방식 : LoadBalance 서비스 Public IP 입력
CLUSTER${IDX}_INGRESS_NGINX_IP=

# Istio Gateway LoadBalancer Service용 External IP
CLUSTER${IDX}_ISTIO_GATEWAY_PRIVATE_IP=
CLUSTER${IDX}_ISTIO_GATEWAY_PUBLIC_IP=

# --------------------------------------------------------------------
# CSP LoadBalancer Controller 설정
# --------------------------------------------------------------------

# CSP 설정 (예: NHN, NAVER)
CLUSTER${IDX}_CSP_TYPE=

# NHN Cloud 환경 변수 (CSP_TYPE=NHN 일때 필수 입력)
CLUSTER${IDX}_NHN_USERNAME=
CLUSTER${IDX}_NHN_PASSWORD=
CLUSTER${IDX}_NHN_TENANT_ID=
CLUSTER${IDX}_NHN_VIP_SUBNET_ID=
CLUSTER${IDX}_NHN_API_BASE_URL=https://kr1-api-network-infrastructure.nhncloudservice.com

# NAVER Cloud 환경 변수 (CSP_TYPE=NAVER 일때 필수 입력)
CLUSTER${IDX}_NAVER_CLOUD_API_KEY=
CLUSTER${IDX}_NAVER_CLOUD_API_SECRET=
CLUSTER${IDX}_NAVER_CLOUD_REGION=KR
CLUSTER${IDX}_NAVER_CLOUD_VPC_NO=
CLUSTER${IDX}_NAVER_CLOUD_SUBNET_NO=
EOF
done
