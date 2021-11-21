# Networking, Network Security, And Service Mesh

## Kubernetes Network Principles

**동일한 포드 내의 컨테이너 간 통신** : 동일한 네트워크를 공유해 localhost 통신이 가능. 동일한 포드 내의 컨테이너는 다른 포트를 열어야 한다.

**포드 간의 통신** : 모든 파드는 네트워크 주소 변환(Network Address Translation)없이 통신할 수 있어야 한다. 즉 수신하는 포드에서 볼 수 있는 송신자의 포드 IP 주소가 실제 IP 주소다.

**서비스와 포드 간의 통신** : 서비스는 IP 주소와 포트를 나타내며 각 노드는 서비스에 연계된 엔드포인트로 트래픽을 전달한다.

## Network Plug-ins

### Kubenet

쿠버네티스에서 바로 사용할 수 있는 가장 기본적인 네트워크 플러그인

### The CNI Plug-in

CNI 명세를 준수하는 플러그인으로 컨테이너를 위한 범용적인 플러그인 네트워크 솔루션. CNI 명세에는 CNI와의 인터페이스, 기본적인 API 동작, 클러스터에서 사용되는 컨테이너 런타임과의 인터페이스

## Services in Kubernetes

서비스 API는 내구성 있는 IP와 포트를 클러스터 내에 할당하고, 서비스의 엔드포인트를 적절한 파드에 자동으로 매핑.
iptables 또는 리눅스 노드의 IP 가상 서버를 통해 할당된 서비스 IP와 포트를 엔드포인트 또는 포드의 실제 IP에 맵핑합니다.
이를 관리하는 컨트롤러는 kube-proxy 서비스이며 클러스터의 각 노드에서 실행되어 iptables 규칙을 조작합니다.

### Service Type Cluster IP

서비스 타입을 명시하지 않을 때 기본값은 ClusterIP(지정된 CIDR 범위 내에서 IP가 할당)다.
서비스를 선언하면 서비스의 DNS 이름이 만들어지고 다음과 같은 패턴을 갖는다. <br>
`<service_name>.<namespace_name>.svc.cluster.local`

### Service Type NodePort

각 노드의 고수준 포트(30000~32767)를 각 노드의 서비스 IP와 포트에 할당합니다. (포트를 정적으로 할당하거나 서비스 명세 안에 명시 가능)

### Service Type ExternalName

CNAME 레코드 및 값을 반환함으로써 서비스를 externalName 필드의 내용(예, `foo.bar.example.com`)에 매핑한다. 어떠한 종류의 프록시도 설정되지 않는다.

### Service Type LoadBalancer

(지원 가능한 경우) 기존 클라우드에서 외부용 로드밸런서를 생성하고 서비스에 고정된 공인 IP를 할당해준다. NodePort의 상위 집합.

### Ingress and Ingress Controllers

인그레스 API는 HTTP 수준의 라우터로, 호스트와 경로 기반 규칙으로 특정 백엔드 서비스에게 트래픽 전달.
인그래스 컨트롤러는 인그래스 API와 분리되어 있으며, 컨트롤러지만 시스템의 일부가 아니며 동적 구성을 위한 쿠버네티스 인그래스 API와 인터페이스하는 서드파티 컨트롤러다.

### Services and Ingress Controllers Best Practices

- 클러스터 외부에서 접근하는 서비스의 수를 제한해야 한다. 대부분의 서비스는 ClusterIP로 두고 외부 접근 서비스만 노출하는 것이 이상적이다.
- 노출 서비스가 주로 HTTP/HTTPS 기반이라면 인그레스 API와 컨트롤러를 사용해 TLS와 함께 트래픽을 서비스로 라우팅하는게 가장 좋다.
- 컨트롤러 구현마다 설정 어노테이션이 다르므로 배포 코드가 쿠버네티스 간에 이식되는 것을 방지해야 한다.

## Network Security Policy

Network Policy API를 사용해 워크로드에 정의된 네트워크 수준의 인그레서/이그레스 접근을 제어할 수 있다.
또한 포드 그룹 간 혹은 다른 엔드포인트로 통신하는 것을 제어할 수 있다.

### Network Policy Best Practices

## Service Meshes

### Service Mesh Best Practices

<br>

## 공부 자료

- [k8s network policies](https://sandeepbaldawa.medium.com/k8s-network-policies-95ba87ac2251)

  > NetworkPolicy : Layer3 & 4에서 작동하며  ip, ports, namespace를 사용해 트래픽 관리
  >
  > ServiceMesh : Layer7에서 작동하며 header, path 등 과 같은 어플리케이션 속성을 활용해 트래픽 관리

- 





<br>

---

위 내용은 `Kubernetes Best Practices - Brendan Burns, Eddie Villalba`를 학습하고 정리한 내용입니다.
