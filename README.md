# paas-ta-container-platform-deployment
## 소개
쿠버네티스 기반의 컨테이너 오케스트레이션 플랫폼의 단독 배포 및 엣지 클라우드 배포 기능을 구현하기 위한 설치에 필요한 파일을 제공합니다. 
- [standalone README](https://github.com/PaaS-TA/paas-ta-container-platform-deployment/tree/dev/standalone)
- [edge README](https://github.com/PaaS-TA/paas-ta-container-platform-deployment/tree/dev/edge)
- [bosh README](https://github.com/PaaS-TA/paas-ta-container-platform-deployment/tree/dev/bosh)

## Configuration
### Kubespray 설치
|주요 소프트웨어|Version|Python Package|Version
|---|---|---|---|
|Kubespray|v2.14.1|ansible|2.9.6|
|Kubernetes Native|v1.18.6|jinja2|2.11.1|
|Docker|v19.03.12|netaddr|0.7.19|
|||pbr|5.4.4|
|||jmespath|0.9.5|
|||ruamel.yaml|0.16.10|

### KubeEdge 설치
|주요 소프트웨어|Version|
|---|---|
|KubeEdge|v1.4.0|
|Kubernetes Native|v1.18.6|
|Docker|v19.03.12|

### 단독 배포 설치
|주요 소프트웨어|Version|
|---|---|
|docker|v35.3.4|
|paasta-container-platform|v1.0|

## Install Guide
### Kubespray 설치 가이드
- [paas-ta-container-platform-standalone-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/standalone/paas-ta-container-platform-standalone-deployment-guide-v1.0.md)

### KubeEdge 설치 가이드
- [paas-ta-container-platform-edge-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/edge/paas-ta-container-platform-edge-deployment-guide-v1.0.md)

### 단독 배포 설치 가이드
- [paas-ta-container-platform-bosh-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/bosh/paas-ta-container-platform-bosh-deployment-guide-v1.0.md)


## Release
- https://github.com/PaaS-TA/paas-ta-container-platform-release/tree/dev
- https://github.com/PaaS-TA/paas-ta-container-platform-release/tree/caas-dev

## License
paas-ta-container-platform-deployment는 [Apache-2.0 License](http://www.apache.org/licenses/LICENSE-2.0)를 사용합니다.
