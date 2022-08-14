## Create Pod

### 조건

- Cluster : k8s
- namespace : ecommerce
- Name : shop-main
- Image : nginx:1.17
- Env : DB=mysql

### Solution

```shell
# Select Cluster
$ kubectl config use-context k8s
# Create Namespace
$ kubectl create namespace ecommerce
# Create Pod
$ kubectl run shop-main --image=nginx:1.17 --env=DB=mysql --namespace ecommerce \
	--dry-run=client -o yaml
```



## Scheduler

스케줄러가 없을때, 아래와 같은 방법으로 manual하게 배포 가능

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  nodeName: ip-10-0-139-120.us-east-2.compute.internal 
  ...
```

 

