## Pull from private docker repo from k8s cluster

[선수 작업(Demo App 배포)](https://github.com/heuristicwave/TIL-DevOps/blob/main/Docker/build_images_and_push_registry.md), [EKS Dashboard Deploy](https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/dashboard-tutorial.html)

Dashboard 로그인에 사용되는 토큰 취득 명령어

```sh
aws-iam-authenticator token -i {EKS-Cluster-Name} --token-only
```

<br>

### Create `Secret` component with Registry credentials

```sh
$ kubectl create secret docker-registry myregistrysecret \
					--docker-server=$DOCKER_REGISTRY_SERVER \
					--docker-username=$DOCKER_USER \
					--docker-password=$DOCKER_PASSWORD \
					--docker-email=$DOCKER_EMAIL
```

> Setting docker-registry
>
> ```shell
> DOCKER_REGISTRY_SERVER=docker.io
> DOCKER_USER=heuristicwave
> DOCKER_EMAIL=heuristicwave@gmail.com
> DOCKER_PASSWORD=
> ```

<br>

### 앱 배포하고 로그 확인하기

```sh
# Private Repo를 사용하는 앱 배포하기 위하 yaml 정의 후 Apply
$ kubectl apply -f ./deployment.yaml

# 포드 Name 확인
$ kubectl get pod

# 올라온 포드 로그 확인
$ kubectl logs {Pod-NAME}
```

<br>

## EFK Stack 구축하기

### EFK Stack

Fluentd (Collect, Send)

- Reformat Data
- Add Metadata(timestamp, data origin source)
- Aggregating and preparing data

Elasticsearch (Store)

Kibana (Visualize)

- Search
- Filter
- Complex queries

> 함께 알면 좋은 지식 
>
> [Deployments VS Statefulsets VS Daemonsets](https://medium.com/stakater/k8s-deployments-vs-statefulsets-vs-daemonsets-60582f0c62d4)

<br>

### Deploy EFK Stack using Helm Chart

[Elasticsearch Helm Chart Github](https://github.com/elastic/helm-charts/blob/master/elasticsearch/README.md) 사용법 확인

```sh
$ helm repo add elastic https://helm.elastic.co

# EKS 30GiB, gp2가 default pvc
$ helm install elasticsearch elastic/elasticsearch # option params : {-f custom-value.yaml}

# Deploy Kibana
$ helm install kibana elastic/kibana

# Check Pod, Pending이 끝나면 다음 단계 진행
$ kubectl get pod
```

> Elasticsearch는 상태값을 유지해야 하므로 `Statefulset` 사용, Fluentd & Kibana는 상태값 유지가 필요 없어 `Deployment`

**키바나 로컬에서 접속하기**

```sh
$ kubectl port-forward deployment/kibana-kibana 5601
```



**Elasticsearch 확인**

```sh
❯ k get all | grep elastic
pod/elasticsearch-master-0           1/1     Running   0          11m
pod/elasticsearch-master-1           1/1     Running   0          11m
pod/elasticsearch-master-2           0/1     Pending   0          11m
service/elasticsearch-master            ClusterIP   172.20.203.74   <none>        9200/TCP,9300/TCP   11m
service/elasticsearch-master-headless   ClusterIP   None            <none>        9200/TCP,9300/TCP   11m
statefulset.apps/elasticsearch-master   2/3     11m
```

`service/elasticsearch-master` : 일종의 로드밸런서, 요청을 특정 pod로 전달
`service/elasticsearch-master-headless` : 특정 pod에 직접 접근 가능한 고유 IP 부여



<br>

### Install nginx-ingress controller

```sh
$ helm repo add stable https://charts.helm.sh/stable 
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm install nginx-ingress ingress-nginx/ingress-nginx
```

> 위 명령어를 통해 각 CSP에서 사용하는 로드밸런서가 생기는데, EKS에서는 CLB 생성



<br>

### Deploy Fluentd

```sh
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install fluentd bitnami/fluentd
```

> 컨테이너 로그 저장 위치 : `/var/lib/docker/containers/$container_id/` 하위



<br>

### [Fluentd Config Syntax](https://docs.fluentd.org/configuration/config-file#list-of-directives)

Config Map의 Data 수정 후 업데이트

- json 형태로 로그 :  `format json` 추가하고 update
- 정해진 `-App`으로 부터 로그 받기
  Before : `/var/log/containers/*.log` After :  `path /var/log/containers/*-app*.log`



**업데이트 후 재배포**

```sh
$ kubectl rollout restart daemonset/fluentd
```



<br>

### Kibana UI

Stack Management => Index Patterns에서 Create index pattern



