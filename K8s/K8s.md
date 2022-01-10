## 기본 명령어

```powershell
kubectl decribe pod {podName}
kubcectl get replicaset
kubectl get pods --all-namespaces
kubectl get pods --show-labels
```

쿠버네티스 API 서버에 전송하는 대신 YAML 형식으로 stdout에 출력하기

```shell
kubectl run {podName} --image={imageName} --dry-run=client -o yaml > sample.yaml
```

쿠버네티스  레플리카 셋 스케일링

```shell
kubectl scale rs {replicasetName} --replicas=5
```

YAML manifest 검사

```shell
kubectl explain replicaset | grep VERSION
kubectl explain deployment | head -n1
```

edit으로 즉시 수정해 반영하기

```shell
kubectl edit {replicaset} {replicasetName}
```

서비스로 특정 포트 노출하기

```shell
kubectl expose pod redis --port=6379 --name redis-service
kubectl run httpd --image=httpd:alpine --port=80 --expose
```

특정 이미지를 사용해 replica 명령형으로 생성하기

```shell
kubectl create deployment {deploymentName} --image={imageName} --replicas=3
```





### 다중 클러스터 접근 구성

```shell
kubectl config view                          # context 이름 확인
kubectl config use-context {my context}
```



### Cheat sheet

[Create a pod that gets scheduled to specific node](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/#create-a-pod-that-gets-scheduled-to-specific-node)
