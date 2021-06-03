# Setting Up a Basic Service

### Managing Configuration Files

애플리리케이션을 파일 시스템의 디렉터리를 이용해 component를 구성하고, 팀에서 필요한 모든 서비스 정의를 단일 디렉터리에 넣습니다.

```shell
$ tree
.
└── journal
    ├── frontend
    ├── redis
    └── fileserver
```

#### Best Practices for Image Management

반드시 잘 알려져 있고 믿을 수 있는 이미지 공급자를 통해서 구축

#### Creating a Replicated Application

- 장애에 대응하거나 rollout을 위해 downtime 발생을 방지하기 위해 최소 2개의 `replica` 실행
- `deployment` 리소스 사용을 권장
- pod를 찾을 수 있도록 label을 사용
- YAML 곳곳에 주석을 작성
- `request`, `limit`의 세밀한 튜닝
  > request : 애플리케이션을 실행하는 호스트 장비가 보장해주는 리소스 크기 <br>
  > limit : 컨테이너가 사용할 수 있는 최대 리소스 크기
- 클러스터 항목과 소스 관리 항목을 일치시키기 위해 GitOps 채택

<br>

### Setting Up an External Ingress for HTTP Traffic

Ingress 리소스는 HTTP 경로와 호스트 기반의 요청을 routing할 수 있는 HTTP(S) 로드 밸런싱 지원, 앞단에 Ingress를 배치하여 서비스 확장 측면에서 유연성을 확보.

<br>

### Configuring an Application with ConfigMaps

환경적 특수성과 민첩성을 위해 애플리케이션과 설정을 분리하는데, 컨피그맵 리소스로 설정을 정의 <br>
컨피그맵 설정 정보는 파드 내의 컨테이너에 파일이나 환경 변수 형태로 전달됨. <br>
컨피그맵 이름에 버전 숫자를 넣으면, 변경할 때 직접 변경하는 대신 v2 컨피그맵을 새롭게 생성하고 디플로이먼트를 변경.
헬스 체크를 통해 자동으로 멈췄다 재시작하며 롤백이 용이함.

<br>

### Managing Authentication with Secrets

쿠버네티스에서 사용할 비밀번호를 시크릿에 저장한 다음, 배포 시점에 실행 중인 애플리케이션과 시크릿을 bind해야 함.

> 시크릿은 암호화되지 않은 상태로 K8s 안에 저장됨. 시크릿을 암호화해서 저장하려면 K8s와 키 공급자를 연동하여 클러스터 내의 모든 시크릿을 암호화할 수 있는 키를 받아야함.
> 시크릿은 tmpfs 램 기반의 파일 시스템으로 볼륨을 생성해 컨테이너에 마운트

<br>

### Deploying a Simple Stateful Database

Stateful 작업을 실행할 때, 원격 PV(NFS, SMB, 클라우드 기반 디스크)를 사용하여 애플리케이션 상태를 처리해야 함.

<br>

### Creating a TCP Load Balancer by Using Services

<br>

### Using Ingress to Route Traffic to a Static File Server

<br>

### Parameterizing Your Application by Using Helm

<br>

### Deploying Services Best Practices

- 대부분의 서비스는 디플로이먼트 리소스로 배포되어야 한다. 디플로이먼트는 중복과 확장을 위해 레플리카를 생성한다.
- 디플로이먼트는 로드밸런서인 서비스를 통해 노출된다. 서비스는 클러스터 내부 혹은 외부에 노출될 수 있다. HTTP 애플리케이션을 노출하려면 인그레스 컨트롤러를 사용할 수 있으며 요청 라우팅과 SSL도 추가할 수 있다.
- 애플리케이션의 설정을 다양한 환경에서 재사용하려면 애플리케이션을 헬름과 같은 패키징 도구를 사용해 파라미터화 해야함.

<br>

---

위 내용은 `Kubernetes Best Practices - Brendan Burns, Eddie Villalba`를 학습하고 정리한 내용입니다.
