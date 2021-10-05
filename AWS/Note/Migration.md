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

> **CLI Configuration**
>
> `~/.aws/config`에 정의
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

## AWS 서비스를 이용한 데이터 마이그레이션

### Storage Gateway

온프레미스에 있는 데이터를 클라우드로 연계하기 위한 입구를 제공하는 서비스

참조 빈도가 높은 데이터는 온프레미스의 고속 스토리지, 참조 빈도가 낮은 데이터나 백업 데이터는 Storage Gateway를 이용해 클라우드에 저장
(VMware, Hyper-V의 가상 이미지가 제공되어 온프레미스에 간단히 도입)

- 파일 Gateway <br>
  S3를 클라이언트 서버에서 NFS 마운트해 파일 시스템과 같이 사용할 수 있음 <br>
  생성된 파일은 비동기이지만 거의 실시간으로 S3에 업로드(고속의 엑세스가 요구되는 경우 사전 테스트 필수)
- 볼륨 Gateway <br>
  S3에 저장하는 것은 파일 게이트웨이와 동일, 각 파일을 Object로 저장하지 않고 Gateway로 사용하는 영역을 볼륨으로 관리 <br>
  클라이언트 서버에서 볼륨 게이트웨이에 연결하는 방식으로 NFS가 아닌 iSCSI 프로토콜 제공 <br>
  - 캐시형(Cache) 볼륨 <br>
    자주 사용하는 데이터를 Storage Gateway의 캐시 디스크에 저장해서 고속 액세스를 가능하게 하고 모든 데이터 저장에 S3을 사용함. 데이터의 양이 증가하더라도 로컬 디스크를 확장할 필요 없이 효율적으로 대용량 데이터를 관리할 수 있습니다.
  - 보관형(Store) 볼륨 <br>
    데이터를 모두 로컬 스토리지에 저장하고, 데이터를 정기적으로 EBS로 사용 가능한 스냅샷 형식으로 S3으로 전송함. 데이터의 백업에 중점을 둔 용도에 적합함.
- 테이프 Gateway

<br>

### Snowball

80TB의 데이터를 저장할 수 있는 하드웨어 장비와 클라이언트 도구를 제공하는 서비스

### Snowball Edge

- 데이터 전송 방식 : S3 API, NFS 통신 프로토콜 지원
- 연결 인터페이스 : 최대 40Gbps의 광섬유 인터페이스 사용, USB 3.0 or PCIe 포트 지원
- 저장 데이터 용량 : 80TB => 100TB, 클러스터링 구성을 통해 PB급 데이터 처리
- S3로 전송할 때의 처리 : Lambda에서 정의한 전처리를 수행할 수 있음

### Snowmobile

100PB까지 한번에 이송

<br>

### Server Migration Service

SMS는 가상 어플라이언스인 Server Migration Connector를 사용해 온프레미스 환경에서 실행되는 가상 머신의 마이그레이션을 지원

- 차분 전송 가능 <br>
  마이그레이션 후, 변경이 생겼을 경우 전 상태에서의 변경을 파악하고 차분만 마이그레이션해 AMI 생성 가능

### Database Migration Service

**DMS와 온프레미스 서버 간의 연결 경로**

| 회선 속도      | 데이터 양                                                                                            |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| 인터넷 경유    | 쌍방 간에는 글로벌 IP로 연결할 필요가 있음 <br> 데이터 암호화를 위해 SSL 인증서를 DMS 측에 설치 가능 |
| VPN 연결       | 초기 마이그레이션에 시간적 여유가 있고, 차분 데이터가 발생하지 않는 경우 가장 현실적인 방법          |
| Direct Connect | 비용 측면에서 부담이 큼                                                                              |

<br>

---

Reference : [AWS 시스템 설계와 마이그레이션](http://www.yes24.com/Product/Goods/67031301)
