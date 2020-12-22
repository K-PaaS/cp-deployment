# PaaS-TA 컨테이너 플랫폼 DEPLOYMENT
## 소개
쿠버네티스 기반의 컨테이너 오케스트레이션 플랫폼의 단독 배포, CaaS 배포, Edge 클라우드 배포을 위한 설치에 필요한 파일을 제공합니다. 

## 설정
### Edge 배포
- KubeEdge :: v1.4.0
- Kubernetes Native :: v1.18.6
- Docker :: v19.03.12

### 단독 배포
- Kubespray :: v2.14.1
- Kubernetes Native :: v1.18.6
- Docker :: v19.03.12
- pbr :: 5.4.4
- jmespath :: 0.9.5
- ruamel.yaml :: 0.16.10
- ansible :: 2.9.6
- jinja2 :: 2.11.1
- netaddr :: 0.7.19
- docker :: v35.3.4
- paasta-container-platform :: v1.0

### CaaS 배포
- Kubespray :: v2.14.1
- Kubernetes Native :: v1.18.6
- Docker :: v19.03.12
- pbr :: 5.4.4
- jmespath :: 0.9.5
- ruamel.yaml :: 0.16.10
- ansible :: 2.9.6
- jinja2 :: 2.11.1
- netaddr :: 0.7.19
- docker :: v35.3.4
- paasta-container-platform :: v1.0

## 가이드	
### 단독 배포 가이드 	
- [paas-ta-container-platform-standalone-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/standalone/paas-ta-container-platform-standalone-deployment-guide-v1.0.md)	
- [paas-ta-container-platform-bosh-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/bosh/paas-ta-container-platform-bosh-deployment-guide-v1.0.md)

### CaaS 배포 가이드
- [paas-ta-container-platform-standalone-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/standalone/paas-ta-container-platform-standalone-deployment-guide-v1.0.md)	
- [paas-ta-container-platform-bosh-deployment-caas-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/bosh/paas-ta-container-platform-bosh-deployment-caas-guide-v1.0.md)	

### Edge 배포 가이드	
- [paas-ta-container-platform-edge-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/edge/paas-ta-container-platform-edge-deployment-guide-v1.0.md)	

## 릴리즈	
- https://github.com/PaaS-TA/paas-ta-container-platform-release/tree/dev	
- https://github.com/PaaS-TA/paas-ta-container-platform-release/tree/caas-dev

## 메인
- https://github.com/PaaS-TA/paas-ta-container-platform/tree/dev

## 라이선스
paas-ta-container-platform-deployment는 [Apache-2.0 License](http://www.apache.org/licenses/LICENSE-2.0)를 사용합니다.
