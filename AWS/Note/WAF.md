### [Listing IP addresses blocked by rate-based rules](https://docs.aws.amazon.com/waf/latest/developerguide/listing-managed-ips.html)

rate-based로 임계값을 지정해 위협 완화, 5분당 요청 2000개를 활용하면 Slow BF를 막고, 사용자별 API 사용량 제한 및 DoS공격 차단
CW 지표를 사용해 발생하는 동작을 관찰하고, 실시간으로 임계값 조정 가능. WAF WebACL 전반에 걸쳐 CF, ALB, API Gateway에 사용할 수 있습니다.
