## Working with records

### Alias

Alias record를 사용하면 CF배포와 S3 버킷 등 선택한 리소스로 트래픽을 라우팅 할 수 있음. 호스트 영역의 한 레코드에서 다른 레코드로 트래픽을 라우팅 할 수 있음.
별칭 레코드를 사용하여 AWS 리소스로 트래픽을 라우팅하면 Route 53이 리소스의 변경 내용을 자동으로 인식.

### [Creating records by using the Amazon Route 53 console](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-creating.html)

- 인터넷 트래픽을 Amazon S3 버킷 또는 Amazon EC2 인스턴스 같은 리소스로 라우팅하려면 퍼블릭 호스팅 영역 생성을 참조.
- VPC에서 트래픽을 라우팅하려면 프라이빗 호스팅 영역 생성을 참조.

<br>

## DNS failover

### Active-active failover

장애가 발생하면 Route 53은 정상 리소스로 돌아감.

### Active-passive

장애가 발생하면 Route 53은 백업 리소스를 반환함.
