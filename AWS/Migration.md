# Data Migration

**소요 시간**
<br>

회선의 사용 효율울 80% 정도 가정
| 회선 속도 | 데이터 양 | 예상 시간 |
| --- | --- | --- |
| 100Mbps | 100GB | 1H 30M |
| 100Mbps | 10TB | 7.5D |
| 1Gbps | 10TB | 17H |
| 1Gbps | 1PB | 74D |

<br>

## AWS 서비스를 사용하지 않는 데이터 마이그레이션

### OS 명령어를 이용한 데이터 마이그레이션

마이그레이션 Target Data가 소량이며, 마이그레이션을 할 때 시스템을 완전히 중단 할 수 있는 경우

- Target Data를 모아 마이그레이션
  ```shell
  $ cd / path/from
  $ tar zcvf data_migration.tar.gz ./data/      # data 폴더를 압축
  $ tar zxvf data_migration.tar.gz -C ./$PATH   # 지정된 경로에 압축 해제
  ```
- Target Data를 파일별로 마이그레이션 <br>
  파일 1개씩 마이그레이션하는 경우 `rsync` 명령
  ```shell
  $ nohup rsync -auzh -e "ssh -i /home/user/.ssh/id_rsa"
  --delete --progress --partial
  --append /path/from/migration/ user@{Target IP}:/$PATH/ &
  ```

### [AWS CLI 명령어를 이용한 데이터 마이그레이션](https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/cli-services-s3-commands.html)

CLI로 S3이관 시, 작은 크기의 대용량 데이터를 업로드하면 오버헤드가 커 전송 속도가 느려짐

```shell
# 동기화 예시, --delete : 원본에 없는 파일이나 객체를 대상에서 제거
$ aws s3 sync /$SOURCE_PATH/ s3://{BUCKET_NAME}/$PATH --delete
```

> **CLI Configuration** > <br> > `~/.aws/config`에 정의
>
> ```
> [profile name]
> s3 =
>     max_current_requests = 20   # 최대 요청 병렬 수, default = 10
>     max_queue_size = 10000      # default, 1000
>     multipart_threshold = 64mb  # 멀티파트 분할 임계값, default = 8mb
>     multipart_chunksize = 16mb  # default = 8mb
> ```
>
> `aws configure set` 명령어
>
> ```shell
> $ aws configure set default.s3.max_current_requests 20
> $ aws configure set default.s3.max_queue_size 10000
> $ aws configure set default.s3.multipart_threshold 64mb
> $ aws configure set default.s3.multipart_chunksize 16mb
> ```

<br>

---

Reference : [AWS 시스템 설계와 마이그레이션](http://www.yes24.com/Product/Goods/67031301)
