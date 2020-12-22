# PaaS-TA 컨테이너 플랫폼 STANDALONE DEPLOYMENT 
## 소개

컨테이너 플랫폼 단독 배포용 Kubernetes 설치를 위한 Kubespray Ansible Playbook 소스 파일 구성입니다. ansible-playbook 명령을 통해 Kubernetes 설치에 필요한 모든 과정이 자동으로 진행됩니다.

## Script 설명
Kubespray는 Ansible playbook으로 배포를 진행 하기 때문에 ansible-playbook 명령을 사용하기 위한 스크립트 파일로 구성 되어 있습니다.

## Configuration
- Kubespray :: v2.14.1
- Kubernetes Native :: v1.18.6
- Docker :: v19.03.12
- pbr :: 5.4.4
- jmespath :: 0.9.5
- ruamel.yaml :: 0.16.10
- ansible :: 2.9.6
- jinja2 :: 2.11.1
- netaddr :: 0.7.19

## 가이드	
### 단독 배포 가이드 	
- [paas-ta-container-platform-standalone-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/standalone/paas-ta-container-platform-standalone-deployment-guide-v1.0.md)	
- [paas-ta-container-platform-bosh-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/bosh/paas-ta-container-platform-bosh-deployment-guide-v1.0.md)

### CaaS 배포 가이드
- [paas-ta-container-platform-standalone-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/standalone/paas-ta-container-platform-standalone-deployment-guide-v1.0.md)	
- [paas-ta-container-platform-bosh-deployment-caas-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/bosh/paas-ta-container-platform-bosh-deployment-caas-guide-v1.0.md)	

## 릴리즈
- https://github.com/PaaS-TA/paas-ta-container-platform-release/tree/dev
- https://github.com/PaaS-TA/paas-ta-container-platform-release/tree/caas-dev

## 메인
- https://github.com/PaaS-TA/paas-ta-container-platform/tree/dev

## 라이선스
[Apache-2.0 License](http://www.apache.org/licenses/LICENSE-2.0)를 사용합니다.
