컨트롤 플레인 : istiod

데이터 플레인 : istio-proxy



## Documents

- [Install Istio](https://istio.io/latest/docs/setup/getting-started/#install)

- [Config profile](https://istio.io/latest/docs/setup/additional-setup/config-profiles/)
- [Istio Operator](https://istio.io/latest/docs/setup/install/operator/)

<br>

## Command

```shell
$ istioctl install --set profile=demo -y

# 데모 Config 보기
$ istioctl profile dump {demo}

# 다른 부분 파악
$ istioctl profile diff {default} {demo}
$ istioctl profile diff a.yaml b.yaml			# file 비교도 가능

# manifest 추출 (metadata)
$ istioctl manifest generate > $HOME/generated-manifest.yaml

# 사이드카로 붙은 이스티오 로그 확인하기
$ kubectl logs {container name} -c istio-proxy

# Proxy 들의 sync 여부
$ istioctl proxy-status

# Proxy 들의 현 config 상태 확인
$ istioctl proxy-config {cluster/endpoint/...} {pod}

# kiali dashboard 진입
$ istioctl dashboard kiali
```

<br>

## 사이드카 인젝션

파드내 네트워크 인터페이스를 컨테이너끼리 공유하는 상황에서 istio-proxy가 inbound/outbound를 모두 선처리

**istioctl로 injection**

```shell
istioctl kube-inject -f deployment-nginx.yaml | k apply -f -
```

**namespace label로 injection (Auto)** 

해당 NS에 뜨는 모든 파드들에 istio가 자동 injection

```shell
kubectl label namespace default istio-injection=enabled --
```

> 특정 파드 injection 거부하기
>
> manifest의 labels 하단에 다음 config 기재 : `sidecar.istio.io/inject: "false"`



[Controlling the injection policy](https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/#controlling-the-injection-policy)

| Resource  | Label                     | Enabled value | Disabled value |
| --------- | ------------------------- | ------------- | -------------- |
| Namespace | `istio-injection`         | `enabled`     | `disabled`     |
| Pod       | `sidecar.istio.io/inject` | `"true"`      | `"false"`      |

<br>

### Gateway

- 프로토콜 및 Gateway port 설정
- proxy, hosts, tls 설정

### VirtualService

- Hosts 등록, L7 path routing(destination policy)

<br>

## Debugging

accessLog가 off일 때, 특정 로그 옵션만 확인하는 방법

```sh
$ k exec -it {pod} -c istio-proxy -- sh

# 로그 옵션 확인
$ curl -X POST localhost:15000/logging

# 로그 옵션 수정
$ curl -X POST localhost:15000/logging?http=debug
```





### [BookInfo Sample](https://istio.io/latest/docs/examples/bookinfo/)

PATH : ~/istio/samples/bookinfo/platform/kube

![bookinfo](https://istio.io/latest/docs/examples/bookinfo/noistio.svg)



> Cleanup
>
> ```
> k delete -f /samples/bookinfo/platform/kube/bookinfo.yaml
> k delete -f /samples/bookinfo/networking/bookinfo-gateway.yaml
> k delete -f /samples/addons
> ```

<br>

### 기타 명령어

```shell
# Hosts file
$ cat /etc/hosts

# Trouble Shooting
$ kubectl exec -it {pod} -c {container} -- {command}

# 특정 컨테이너 로그 출력
$ kubectl logs {pod} -c {container}

kubectl get svc -n istio-system
curl -XGET localhost:80 -v
```

   

