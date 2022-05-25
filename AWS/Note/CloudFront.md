## Controlling cache

### Testing TTL

macOS/Linux (윈도우는 /dev/null 대신 NUL), `< AGE:` 부분을 통해 TTL 확인

```shell
curl -v -o /dev/null http://[CloudFront endpoint]/test/cache.test
```

<br>

## Improve performance

### Static contents dowoload test

아래 코드를 S3 주소와, CF 주소를 각각 넣어 테스트

```shell
for i in `seq 1 10`; do echo $i; curl -s -o /dev/null --write-out "size_download: %{size_download} // time_total: %{time_total} // time_starttransfer: %{time_starttransfer}\n" http://[s3WebsiteDomain or CF endpoint]/test/download.test; done
```

> Dynamic contents의 경우, Cache policy를 CachingDisabled로 선택한다.
>
> 위 명령어의 `time_total`와 `time_starttransfer(includes DNS lookup, TCP connection, TLS connection, and HTTP request sent)` 값을 비교하면 거의 차의가 없는 것을 확인 가능

<br>

### Compression

압축을 가하기 전 원본의 크기

```shell
curl -s -o /dev/null -w 'size_download: %{size_download}\n' https://[s3WebsiteDomain]/test/compress.txt
```

압축을 가한 CF에서 Header를 조회한 크기 조회 (`Accept-Encoding:gzip`, `Accept-Encoding:br`)

```shell
curl -s -o /dev/null -H 'Accept-Encoding:gzip' -w 'size_download: %{size_download}\n' http://[CloudFront endpoint]/test/compress.txt
```

### Origin Shield

CloudFront 캐싱 인프라의 추가 계층으로 오리진의 부하를 최소화하고 가용성을 높임
