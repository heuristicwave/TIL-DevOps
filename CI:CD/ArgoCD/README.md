## EKS에 Argo CD 설치하기

### Kubectl command

```shell
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

kubectl get pods -n argocd -o wide	# 확인
```

### Argo CD CLI 설치

```shell
brew tap argoproj/tap
brew install argoproj/tap/argocd

argocd	# 확인
```

### 초기 계정 설정

```shell
export ARGOCD_SERVER=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
echo $ARGOCD_SERVER	# login password에 사용을 위해 해당 값 복사

export ARGOCD_ENDPOINT=$(kubectl get svc argocd-server -o json -n argocd | jq -r '.status.loadBalancer.ingress[0].hostname')
echo $ARGOCD_ENDPOINT	# 브라우저에서 접속 할 엔드포인트

argocd login $ARGOCD_ENDPOINT:80 --grpc-web	# 로그인 후, y옵션
Username: admin
Password: $ARGOCD_SERVER

argocd account update-password	# 초기 비밀번호 변경
```

### 엔드포인트로 접속해 프로젝트 생성

1. Settings => Repositories

2. New App => GENERAL 

   Set Application Name(demo), Project(default)

3. Set SOURCE

4. Set DESTINATION (default)

### Manifest 파일 Push 후, Sync

<br>

## Argo Rollouts

### K8s RollingUpdate

ReplicaSet이 4개일 경우, 기존 ReplicaSet을 1개 줄이고 새로운 ReplicaSet을 1개 늘리며 점진적으로 업데이트를 진행한다.

아래와 같이 K8s의 배포 전략을 세운다면, Pod를 하나씩 생성하지 않고 한번에 3개를 생성한다.

```yaml
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 3
      maxUnavailable: 3
```

위와 같이 업데이트 시점에 2개의 버전이 공존하게 된다. 이를 해결하기 위한 방법 중 하나로  [Argo Rollouts](https://argoproj.github.io/argo-rollouts/getting-started/) 라이브러리를 사용된다.

설치 방법은 [Finda 기술블로그](https://medium.com/finda-tech/argo-cd%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-%EB%8B%A4%EC%96%91%ED%95%9C-%EB%B0%B0%ED%8F%AC-%EB%B0%A9%EC%8B%9D%EC%9D%84-%EC%A7%80%EC%9B%90%ED%95%98%EB%8A%94-%EB%9D%BC%EC%9D%B4%EB%B8%8C%EB%9F%AC%EB%A6%AC-argo-rollouts-3a205abf7261), [Tei's Tech Note](https://teichae.tistory.com/entry/Argo-CD%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-BlueGreen-%EB%B0%B0%ED%8F%AC-3) 에 잘 설명 되어있다.



<br>

---

Reference : [Finda 기술블로그](https://medium.com/finda-tech/eks-cluster%EC%97%90-argo-cd-%EB%B0%B0%ED%8F%AC-%EB%B0%8F-%EC%84%B8%ED%8C%85%ED%95%98%EB%8A%94-%EB%B2%95-eec3bef7b69b), [Subicura 쿠버네티스 안내서](https://subicura.com/k8s/guide/deployment.html#%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9-%E1%84%8C%E1%85%A5%E1%86%AB%E1%84%85%E1%85%A3%E1%86%A8-%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8C%E1%85%A5%E1%86%BC)

