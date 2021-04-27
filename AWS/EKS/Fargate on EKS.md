# AWS Fargate on EKS

- Control Plane + Data Plane의 완전한 서버리스화
- coreDNS, add-on 등을 모두 Fargate에 Deploy 가능
- 기존 Node Group과 함께 하이브리드 형태의 워크로드 운영 가능

## 장점

1. Cluster Autoscaler를 사용할 필요가 없음
2. 비용 청구의 단위가 Pod의 실행 시간이 됨
3. Pod를 사용해도 VM 수준의 격리가 가능
4. 기존 어플리케이션의 변경 없이 Fargate로 이전 가능

## 제약 사항

1. 리소스 상한선 존재 (최대 4vCPU, 30GB 메모리)
2. Stateless한 워크로드 사용 권고
3. Privileged Pod 사용 불가능 (Daemonset)
4. NLB/ELB 사용 어려움 (ELB + Ingress 조합 가능)

### Use Case

EKS를 Fargate와 EC2 인스턴스 영역으로 나눠 사용

- Fargate on EKS에는 Stateless한 서버
- EKS에는 Stateful한 서버

### 설치

```shell
$ eksctl create cluster --name {} --region {} fargate
```

## Fargate Profile

?

## Fargate on EKS 내부 구조

### EKS + Fargate 네트워크 구조

1 개의 Pod = 1 개의 Node, 최대 5천개의 Pod만 사용 가능

### Fargate on EKS에서 Pod의 스케줄링

?

### 요금 체계

추가

- 사용한 vCPU 및 메모리 리소스 기반 과금
- 일시 작업은 스팟 인스턴스 사용 (최대 90% 할인)
- 사용량이 일정하다면 Savings Plans (최대 50% 할인)

<br>

---

참고 자료 : [AWS Fargate on EKS 실전 사용하기 - 용찬호 (데브시스터즈) :: AWS Community Day 2020](https://www.youtube.com/watch?v=N0uLK5syctU)
