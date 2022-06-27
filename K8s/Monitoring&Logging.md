# Monitoring and Logging in K8s

### Metrics vs Logs

**매트릭** : 특정 기간에 측정한 일련의 숫자 <br>
**로그** : 시스템을 분석하기 위해 사용

### Command

2개 이상의 pod일때 선택하여 로그 보기

```shell
kubectl logs <pod name> -c <container name>
```

<br>

## Monitoring Patterns

**USE 패턴**(인프라 컴포넌트 중점) : Utilization(사용률) / Saturation(포화도) / Error(오류율) <br>

**RED 패턴**(애플리케이션 UX 중점) : Request(요청) / Error(오류율) / Duration(소요시간) <br>

**Four Golden Signals** : 레이턴시 / 트래픽 / 오류율 / 포화도 <br>

<br>

## Kubernetes Metrics Overview

컨트롤 플레인 : API 서버, etc, 스케줄러, 컨트롤러 매니저 <br>

워커노드 : kubelet, 컨네이너 런타임, kube-proxy, kube-dns, pod <br>

### cAdvisor (컨테이너 어드바이저)

kubelet에 내장되어 클러스터의 모든 노드에서 실행 중인 컨테이너의 리소스와 메트릭을 수집. 리눅스 cgroups 트리를 통해 메모리와 CPU 메트릭을 수집

> cgroups는 CPU, 디스크 IO, 네트워크 IO 리소스를 고립시킬 수 있는 리눅스 커널 기능. 리눅스 커널에 내장된 statfs를 이용해 메트릭을 수집

<br>

### Metris Server

쿠버네티스 메트릭 서버와 API를 두가지 측면에서 이해할 수 있다.

1. 리소스 메트릭 API의 표준 구현체가 메트릭 서버, 이는 CPU와 메모리 같은 리소스 메트릭을 수집한다. kubelet API로부터 수집하며 메모리에 저장.
2. 사용자 정의 메트릭 API를 이용해 모니터링 시스템에서 임의의 메트릭을 수집할 수 있습니다.

<br>

### kube-state-metrics

[kube-state-metrics](https://github.com/kubernetes/kube-state-metrics/tree/master/docs)는 K8s에 저장된 오브젝트를 모니터링할 수 있는 추가 기능. 자세한 메트릭을 제공하지는 않지만 클러스터에 배포된 오브젝트의 상태를 파악하는데 중점을 둔 기능

- 파드
  - 클러스터에 몇 개의 파드가 배포?
  - 대기 중인 파드는 몇 개?
  - 파드 요청을 처리할 만큼 충분한 리소스가 있는가?
- 디플로이먼트
  - 의도한 상태에서 수행 중인 파드는 몇 개?
  - 몇 개의 레플리카가 가용한가?
  - 어떤 디플로이먼트가 업데이트되었나?
- 노드
  - 워커 노드의 상태는 어떠한가?
  - 클러스터에 할당할 수 있는 CPU 코어는 몇 개인가?
  - 스케줄되지 않는 노드가 있는가?
- 잡
  - 언제 시작
  - 언제 완료
  - 몇 개의 잡이 실패?

<br>

## What Metrics Do I Monitor?

K8s에서 모니터링할 때는 다음과 같은 계층적 방식을 취해야 한다.

- 물리적 혹은 가상의 노드
  - CPU/메모리/네트워크/디스크 사용률
- 클러스터 컴포넌트
  - Etcd 레이턴시
- 클러스터 추가 기능
  - 클러스터 오토스케일러
  - 인그레스 컨트롤러
- 최종 사용자 애플리케이션
  - 컨테이너 메모리 사용률과 포화도
  - 컨테이너 CPU 사용률
  - 컨테이너 네트워크 사용률과 오류율
  - 애플리케이션 프레임워크 특정 메트릭

<br>

## Monitoring Kubernetes Using Prometheus

![soundcloud-prometheus](https://developers.soundcloud.com/blog/6ad4784882b3758430eea84a3c25486b/prometheus_architecture.svg)

- **Prometheus Server** : 메트릭 엔드포인트로부터 메트릭을 수집하여 저장. (Pull 모델 사용)
- **Prometheus Operator** : 프로메테우스 설정을 K8s 네이티브로 만들고 `alertmanager` 클러스터를 관리하고 운영. 사용자는 K8s 네이티브 리소스 정의를 통해 프로메테우스 리소스를 생성, 제거, 설정할 수 있습니다.
- **Exporter(Node-Exporter)** : 모니터링 대상이 프로메테우스의 데이터 포맷을 지원히자 않는 경우 별도의 에이전트를 설치하는데 이를 Exporter라고 한다. (Node-exporter, nginx-exporter, redis-exporter, mysql-exprter)
- **AlertManager** : 프로메테우스로부터 alert를 전달받아 적절한 포맷으로 가공해 notify 해줌.

> [프로메테우스 모니터링의 장단점](https://twofootdog.tistory.com/17)
>
> 장점 : 모든 이벤트를 데이터에 Push하는 ELK의 방식과는 달리 일정 간격 마다 데이터를 수집하기 때문에 저사양의 스펙으로 모니터링 시스템 구축이 가능하다. 설정파일을 프로메테우스 서버 설정파일만 변경 후, node-exporter는 배포만 하면 되기 때문에 시스템 운영이 용이하다.
>
> 단점 : Pull 방식으로 일정 간격마다 데이터를 수집하기 때문에 모든 이벤트를 수집하는 일이나 배치 작업 등 단발적으로 발생하는 업무 모니터링에는 적합하지 않다. 기본적인 구조로는 Scale-out을 구현하는데 한계가 있어 많은 이벤트가 발생하는 시스템을 모니터링 하는데 적합하지 않다.

<br>

## Logging Overview

전체 환경을 보기위해 K8s 클러스터와 클러스터에 배포된 앱으로 부터 로그를 수집해 중앙집중화 해야 한다. 모든 것을 기록 하면 아래와 같은 2가지 문제가 발생한다.

- 너무 많은 노이즈 때문에 문제를 빠르게 발견하기 어렵다.
- 많은 리소스 사용으로 인한 높은 비용이 발생한다.

로그의 문제가 커지는 것을 해결하기 위해 보관 기간과 정책을 규정해야 하는데, 최종 UX를 통해 살펴보면 30 ~ 45일 사이의 로그를 보관하는 것이 좋다.

<br>

클러스터에는 여러 컴포넌트 로그가 있는데 수집해야 할 컴포넌트는 아래와 같다.

- **노드 로그** : 핵심 노드 서비스에서 발생한 이벤트 수집 (워커 노드에서 실행 중인 도커 데몬 로그)
- **컨트롤 플레인 로그**
  - API 서버 / 컨트롤러 관리자 / 스케줄러
  - `/var/log/kube-APIserver.log`, `/var/log/kube-scheduler.log`, `/var/log/kube-controller-manager.log` 로그 집계
- **Audit 로그** : 노이즈가 많기에 환경에 맞게 감사 로그 모니터링 가이드를 준수해 수정해야 함.
- **애플리케이션 컨테이너 로그** : 모든 로그를 표준 출력으로 보내거나, 사이드카 패턴을 이용

<br>

### [Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)

로깅 에이전트는 모든 노드에서 실행해야 하므로, 로깅 도구는 **DaemonSet**으로 실행되어야 한다. 또한 표준 출력으로 로그를 보낼 수 없는 애플리케이션을 위해 사이드카로도 실행될 수 있어야 한다.

<br>

## Best Practice for Monitoring, Logging and Alerting

**모니터링**

- 노드와 쿠버네티스의 모든 **컴포넌트**에 대한 **사용률, 포화도, 오류율** & **애플리케이션**의 **속도, 오류, 시간** 모니터링
- 시스템의 **예측하기 힘든 상태와 징후**를 모니터링 할 때는 **블랙박스 모니터링** 사용
- 시스템의 **내부를 조사**할 때는 **화이트박스 모니터링** 사용
- 정확도가 높은 메트릭을 얻으려면 시계열 기반 메트릭 구현 (애플리케이션 동작에 대한 통찰을 얻을 수 있음)
- 평균 메트릭을 사용해 실제 데이터 기반의 하위 합계와 메트릭을 시각화. 합계 메트릭을 이용해 특정 메트릭의 분포를 시각화

**로깅**

- 전반적인 분석을 위해 메트링과 함께 로깅
- 너무 많은 리소스를 사용하므로 사이드카 패턴에서 로그 전달자를 제한적으로 사용. (데몬셋 지향)

**알림**

- 알림 피로를 조심. 사람과 프로세스에 악영향
- 처음부터 완벽할 수 없음. 점진적으로 개선
- 즉각적인 대응이 필요 없는 일시적 문제는 알림하지 않음 (자동으로 문제 해결하기, ex : liveness probe로 응답 없는 프로세스 자동 복원)
- SLO와 고객에게 영향을 미치는 징후를 알림
- Alert threshold(임계치)를 고려 (너무 짧으면 많은 알람, 표준 임계치를 알아 두자)
- 관련 정보를 제공 (ex : 데이터 센터, 지역, 앱 소유자, 영향 받는 시스템 등의 정보)

---

참고자료 : `Kubernetes Best Practices - Brendan Burns, Eddie Villalba`
