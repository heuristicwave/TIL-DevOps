## Image

```shell
docker image inspect ${Container_ID}
```



### Dockerfile 없이 이미지 생성

소스 컨테이너를 기반으로 이미지 생성하기

```shell
docker commit -a ${Container_Name} -m "Commit Message" ${Source_Container} [Repository[:TAG]]
```



### [Dockerfile](https://docs.docker.com/engine/reference/builder/)



### Save

```shell
# Save
docker save -o [File Name] IMAGE
# Load
docker load -i [File Name].tar
```



## Image lightweight

1. 필요한 패키지 및 파일만 추가
2. 레이어 수 최소화 (RUN 명령어 최소화)
3. 경량 베이스 이미지 사용
4. 멀티 스테이지 빌드 사용
