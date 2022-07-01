## 기본 명령어

```powershell
kubectl decribe pod {podName}
kubcectl get replicaset
kubectl get pods --all-namespaces
kubectl get pods --show-labels
```

쿠버네티스 API 서버에 전송하는 대신 YAML 형식으로 stdout에 출력하기

```shell
# Create Pod
kubectl run <podName> --image=<imageName> --dry-run=client -o yaml > sample.yaml
# Create Static Pod
kubectl run --restart=Never --image=<imageName> <podName> \
 --dry-run=client -o yaml \
 -- command sleep 1000
```

쿠버네티스 레플리카 셋 스케일링

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
kubectl edit <deployments name>
kubectl edit replicaset <replicaset name>
```

특정 파일로 대체하기

```shell
kubectl replace -f <file name> --force
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

### DaemonSet

```shell
kubectl get daemonsets --all-namespaces
kubectl describe daemonset kube-flannel-ds --namespace=kube-system
```

### Labels

Label 정보 얻기

```shell
kubectl describe node <node name>
kubectl get node <node name> --show-labels
```

Label 부여하기

```shell
kubectl label node <node name> key=value
```

### 다중 클러스터 접근 구성

```shell
kubectl config view                          # context 이름 확인
kubectl config use-context {my context}
```

### Drain

`drain`은 `cordon`과 비교하여 unschedule + evict후, 다른 노드에서 재생성

```shell
kubectl drain <node> --ignore-daemonsets
# undrain
kubectl uncordon <node>
```

> `--force` 로 강제로 evict 시킬 경우 lost forever
> 
> `cordon`으로 현재 노드에 배포된 Pod은 그대로 유지하면서, 추가적인 Pod의 배포를 제한

## Upgrade

Check latest stable version available for upgrade

```shell
kubeadm upgrade plan
```

Upgrade

```shell
apt update
# Upgrade kubeadm
apt install kubeadm=1.20.0-00
kubeadm upgrade apply v1.20.0
# Upgrade kubelet
apt install kubelet=1.20.0-00
system restart kubelet
```

### Cheat sheet

[Create a pod that gets scheduled to specific node](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/#create-a-pod-that-gets-scheduled-to-specific-node)
