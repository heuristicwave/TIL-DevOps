# Fluentd로 CW에 저장하기



## 필요한 정책 추가하기

`CloudWarchAgentServerPolicy` 정책 연결



## Namespace 생성

`amazon-cloudwatch` 이름으로 생성하거나 아래 명령어 실행

```shell
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cloudwatch-namespace.yaml
```



## FluentD 설치

### ConfigMap 생성

```shell
kubectl create configmap cluster-info \
--from-literal=cluster.name={cluster_name} \
--from-literal=logs.region={region_name} -n amazon-cloudwatch
```

### DaemonSet으로 클러스터 배포

```shell
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/fluentd/fluentd.yaml
```

> 수집 할 로그 대상 수정하기
>
> `path /var/log/containers/*.log` 부분을 수정하여 원하는 곳만 로그를 받아 볼 수 있다.

### 설치 확인 (아래 명령어의 로그를 통해 Troubleshooting)

```shell
kubectl get configmap/cluster-info -n amazon-cloudwatch -o yaml

kubectl -n amazon-cloudwatch get daemonset
kubectl -n amazon-cloudwatch get po
kubectl -n amazon-cloudwatch logs -f fluentd-cloudwatch-{}
```

https://console.aws.amazon.com/cloudwatch/ 에서 로그 그룹 확인하기



<br>

---

Reference : [AWS docs container insights setup logs](https://docs.aws.amazon.com/ko_kr/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-logs.html)

