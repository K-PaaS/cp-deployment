# paas-ta-container-platform-standalone-deployment
## 소개

컨테이너 플랫폼 단독 배포용 Kubernetes 설치를 위한 Kubespray Ansible Playbook 소스 파일 구성입니다.ansible-playbook 명령을 통해 Kubernetes 설치에 필요한 모든 과정이 자동으로 진행됩니다.

## Configuration
|주요 소프트웨어|Version|Python Package|Version
|---|---|---|---|
|Kubespray|v2.14.1|ansible|2.9.6|
|Kubernetes Native|v1.18.6|jinja2|2.11.1|
|Docker|v19.03.12|netaddr|0.7.19|
|||pbr|5.4.4|
|||jmespath|0.9.5|
|||ruamel.yaml|0.16.10|

## Install Guide
### Kubespray 설치 가이드
- [paas-ta-container-platform-standalone-deployment-guide](https://github.com/PaaS-TA/paas-ta-container-platform/blob/dev/install-guide/standalone/paas-ta-container-platform-standalone-deployment-guide-v1.0.md)

## Release
- https://github.com/PaaS-TA/paas-ta-container-platform-release/tree/dev
- https://github.com/PaaS-TA/paas-ta-container-platform-release/tree/caas-dev

## License
paas-ta-container-platform-standalone-deployment는 [Apache-2.0 License](http://www.apache.org/licenses/LICENSE-2.0)를 사용합니다.
