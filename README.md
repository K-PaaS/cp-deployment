# PaaS-TA 컨테이너 플랫폼 DEPLOYMENT
## 소개
쿠버네티스 기반의 컨테이너 오케스트레이션 플랫폼의 단독 배포, CaaS 배포, Edge 클라우드 배포을 위한 설치에 필요한 파일을 제공합니다. 
- standalone
  + [README.md](https://github.com/PaaS-TA/paas-ta-container-platform-deployment/tree/dev/standalone)
- edge 
  + [README.md](https://github.com/PaaS-TA/paas-ta-container-platform-deployment/tree/dev/edge)
- bosh 
  + [README.md](https://github.com/PaaS-TA/paas-ta-container-platform-deployment/tree/dev/bosh)

## 설정
### 단독배포
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

### Edge 배포
- KubeEdge :: v1.4.0
- Kubernetes Native :: v1.18.6
- Docker :: v19.03.12

## License
paas-ta-container-platform-deployment는 [Apache-2.0 License](http://www.apache.org/licenses/LICENSE-2.0)를 사용합니다.
