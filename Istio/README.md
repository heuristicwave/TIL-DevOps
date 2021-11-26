[Install Istio](https://istio.io/latest/docs/setup/getting-started/#install)

- [Config profile](https://istio.io/latest/docs/setup/additional-setup/config-profiles/)



### Command

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
```

<br>

### 사이드카 인젝션

**istioctl로 injection**

```shell
istioctl kube-inject -f deployment-nginx.yaml | k apply -f -
```

**namespace label로 injection**

```shell
kubectl label namespace default istio-injection=enabled --
```

> 특정 파드 injection 거부하기
>
> manifest의 labels 하단에 다음 config 기재 : `sidecar.istio.io/inject: "false"`



### [BookInfo Sample](https://istio.io/latest/docs/examples/bookinfo/)



### 기타 명령어

```shell
# Trouble Shooting
$ kubectl exec -it {pod} -c {container} -- {command}

kubectl get svc -n istio-system
curl -XGET localhost:80 -v
```

   

