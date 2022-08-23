## [Envoy](https://www.envoyproxy.io/docs) (istio-proxy/데이터 플레인)

- C++로 구현된 고성능 프록시
- 다양한 필터체인 지원
- L3/L4 필터
- HTTP L7 필터



![envoy](https://www.envoyproxy.io/docs/envoy/latest/_images/lor-architecture.svg)



Cluster : envoy가 트래픽을 포워드할 수 있는 논리적인 서비스

Endpoint : ip address처럼 네트워크 노드로 그룹핑

<br>

### [Run Envoy](https://www.envoyproxy.io/docs/envoy/latest/start/quick-start/run-envoy#run-envoy-with-the-demo-configuration)