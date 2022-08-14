## Static Pod

API 서버 없이 특정 노드에 있는 kubelet 데몬에 의해 직접 관리

파드 정의 위치 : `/etc/kubernetes/manifests`



### 조건

- Node : k8s-w1
- Pod Name : web
- Image : nginx

### Solution

```shell
# Select Node
$ ssh k8s-w1 && sudo -i
# Confirm Configuration, get static pod path
$ cat /var/lib/kubelet/config.yaml
```





### Command

```shell
# Filtering using kubectl
kubectl get pods --all-namespaces -o json | jq -r '.items | map(select(.metadata.labels.tier == "control-plane" ) | .metadata.name) | .[]'

# static pod definition files
ps -aux | grep kubelet
/var/lib/kubelet/config.yaml

```

