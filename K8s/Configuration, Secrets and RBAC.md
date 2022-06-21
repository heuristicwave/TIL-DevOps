# Configuration, Secrets and RBAC

### ConfigMaps

컨피그맵 API를 이용해 민감하지 않은 문자열 데이터를 파드, 컨트롤러, CRD, 오퍼레이터 등 복잡한 시스템 서비스에 전달받은 설정 정보를 주입. 컨피그맵은 유연성이 뛰어나 key/value, JSON, XML과 같은 벌크 데이터, proprietary configuration 데이터를 전달할 수 있다. 설정 정보를 파드에 전달할 뿐만 아니라 컨트롤러, CRD, 오퍼레이터 등 복잡한 시스템 서비스로도 정보를 제공할 수 있다.

ConfigMap의 Data를 참조하는 방법

```shell
envFrom:
- configMapRef:
    name: special-config
---
env:
  - name: SPECIAL_LEVEL_KEY
    valueFrom:
      configMapKeyRef:
        name: special-config
        key: SPECIAL_LEVEL
```

### Secrets

시크릿 데이터 : base64로 인코딩된 데이터에 기본 크기가 1MB로 제한되는 소량의 데이터로 3가지 타입이 있다.

- `generic` : 파일 디렉터리로 생성되거나 다음과 같은 문자열 리터럴로 생성된다.
  
      kubectl create secret generic {mysecret} --from-literal={key1} --from-literal={key2}
      # 예시
      kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123

- `docker-registry` : Private Docker Registry 인증에 필요한 정보

- `tls` : public/private key pair로 TLS 시크릿을 생성.

시크릿은 자신을 사용하는 파드가 있는 노드의 tmpfs에만 마운트. 파드가 종료되면 시크릿은 삭제되어 노드의 디스크에 시크릿이 남은 상황을 방지.
그러나 기본적으로 시크릿은 etcd 데이터 스토리지에 평범한 텍스트로 저장되어 etcd 노드 간의 상호 전송 계층 보안 및 etcd에 데이터를 저장할 때 암호화를 하는 등 etcd 환경의 보안에도 신경을 써야한다.

<br>

## Common Best Practices for the ConfigMap and Secrets APIs

1. 새로운 버전의 포드를 다시 배포하지 않고 앱을 동적으로 변경하려면 컨피그맵과 시트릿을 볼륨으로 마운트한다.
2. 포드가 배포되기 전, 이를 소비할 포드의 네임스페이스 안에 컨피그맵/시크릿이 존재해야 한다. 옵션 플래그를 사용하면 컨피그맵/시크릿이 없는 경우 파드가 시작되지 않도록 할 수 있다.
3. 

<br>

## RBAC

쿠버네티스에는 여러 권한 방식이 있지만, RBAC을 가장 많이 사용합니다. RBAC은 여러 API 기능에 대한 세밀한 접근을 제어할 수 있습니다.

### 주요 컴포넌트

1. Subjects : 실제로 접근을 확인해야 하는 항목. 통상 user, service account, group. 사용자와 그룹은 권한 모듈을 이용해 K8s 외부에서 관리한다. (x.509 클라이언트 증명, bearer token 등으로 분류)
2. Rules : API로 특정 객체(리소스)나 객체 그룹을 실행할 수 있는 기능
3. Role : 정의된 규칙을 적용할 범위. 쿠버네티스에는 role과 clusterRole이 존재.
   
   > role : 하나의 네임스페이스에 적용 <br>
   > clusterRole : 모든 네임스페이스, 클러스터에 걸쳐 적용
4. Role Binding : 사용자나 그룹을 특정 롤에 매핑

### Best Practices

- 애플리케이션 코드가 실제로 K8s API와 직접 상호작용할 떄만 RBAC 설정이 필요
- p96

<br>

---

참고자료 : `Kubernetes Best Practices - Brendan Burns, Eddie Villalba`
