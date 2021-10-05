# Event-Driven

<br>

## SNS

**SNS**(Publish 역할)와 **SQS**(Subscriber)를 사용해 **pub/sub** 구현하기



### Process

1. SQS에서 대기열 생성
2. SQS에서 만들어진 대기열의 **SNS Subscription에서 SNS의 topic** 지정
3. SNS에서 topic 선택하면, Subscription 목록을 확인 할 수 있음.
4. 3번에서 확인된 Subscription을 선택해 **필터 정책** 설정
5. 대기열 Purge

