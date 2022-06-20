## Layer

1. Image Layers (Read Only)

   ```shell
   docker build -t app .
   ```

2. Container Layer (Read, Write)

   ```sh
   docker run app
   ```

   



## Command

```shell
docker inspect {Container ID}
docker system info
docker network ls
```



## Entrypoint

도커 컨테이너가 실행할 때 고정적으로 실행되는 스크립트 혹은 명령어
생략 가능하며, 생략될 경우 커맨드에 지정된 명령어로 수행



엔트리포인트로 `sh` 설정

```shell
docker run --entrypoint sh {nginx}
```



## Command

도커 컨테이너가 실행할 떄 수행할 명령어 혹은 엔트리포인트에 지정된 명령어에 대한 인자 값



## Environment

```sh
# 환경변수 주입
docker run -it -e KEY=value {ubuntu} bash
# 환경변수 파일 주입
docker run -it --env-file ./test.env {ubuntu} env
# 주입된 환경 변수 확인
docker exec {nginx} env
```



## Volume

Host Volume

```shell
# 호스트의 /opt/html 디렉토리를 nginx의 루트 디렉토리로 마운트
docker run -d --name nginx \
-v /opt/html:/usr/share/nginx/html \
nginx
```

Volume Container

```shell
docker run -d --name nginx \
--volumes-from my-volume \
nginx
```

Docker Volume

`/var/lib/docker/volumes/${volume-name}/_data`에 데이터가 저장

```shell
# 도커의 test 볼륨을 nginx 웹 루트 디렉토리로 읽기 전용 마운트(:ro)
docker run -d --name nginx \
-v test:/usr/share/nginx/html:ro \
nginx
```



## Logs

호스트 운영체제의 로그 저장 경로 : `/var/lib/docker/containers/${CONTAINER_ID}/${CONTAINER_ID}-json.log`

### 로그 용량 제한

```shell
docker run -d \
--log-driver=json-file \
--log-opt max-size=3m \
--log-opt max-file=5 \
nginx
```



# Debugging

```shell
docker system events
journalctl -u docker
docker system df -v
docker stats
```



