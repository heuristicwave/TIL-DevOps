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



---

Reference : [Finda 기술블로그](https://medium.com/finda-tech/eks-cluster%EC%97%90-argo-cd-%EB%B0%B0%ED%8F%AC-%EB%B0%8F-%EC%84%B8%ED%8C%85%ED%95%98%EB%8A%94-%EB%B2%95-eec3bef7b69b)