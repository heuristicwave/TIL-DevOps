## Pull from private docker repo from k8s cluster

[선수 작업](https://github.heuristicwave.com)

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

### Deploy Elasticsearch using Helm Chart

[Elasticsearch Helm Chart Github](https://github.com/elastic/helm-charts/blob/master/elasticsearch/README.md) 사용법 확인



```sh
$ helm repo add elastic https://helm.elastic.co
```



