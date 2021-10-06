# Event-Driven

### Event Pattern \* [콘텐츠 필터링 기법](https://docs.aws.amazon.com/ko_kr/eventbridge/latest/userguide/eb-event-patterns-content-based-filtering.html)

```json
// JSON { key : value}
{
  "detail": {
    "location": ["eu-west", "eu-east"]
  }
}
// Using Prefix
{
  "detail": {
    "location": [ { "prefix": "us-" } ],
    "location": [ { "anything-but": "us-east" } ]
  }
}
```

<details>
<summary> Send Event </summary>

#### CLI

```shell
aws events put-events \
--entries EventBusName=Orders,Source=com.aws.orders,DetailType="Order Notification",Detail="{ \"category\" : \"lab-supplies\", \"location\" : \"us-west\", \"value\" : 415}"
```

#### Javascript - SDK

```javascript
var AWS = require("aws-sdk");
AWS.config.update({ region: "us-west-2" });
var params = {
  Entries: [
    {
      Detail: { category: "lab-supplies", location: "us-west", value: 415 },
      DetailType: "Order Notification",
      EventBusName: "Orders",
      Source: "com.aws.orders",
    },
  ],
};
var putEventsPromise = new AWS.CloudWatchEvents().putEvents(params).promise();
putEventsPromise
  .then(function (data) {
    console.log(
      `Event sent to the event bus ${params.Entries[0].EventBusName}`
    );
    console.log(`EventID is ${data.Entries[0].EventId}`);
  })
  .catch(function (err) {
    console.error(err, err.stack);
  });
```

#### Python - SDK

```python
import boto3
client = boto3.client('events')

event_bus_name = 'Orders'
source = 'com.aws.orders'
detail_type = 'Order Notification'
detail = '{ "category" : "lab-supplies", "location" : "us-west", "value" : 415 } '

try:
    response = client.put_events(
       Entries=[
         {
           'Source': source,
           'DetailType': detail_type,
           'Detail': detail,
           'EventBusName': event_bus_name
         }
       ]
    )
    print('Event sent to the event bus ' + event_bus_name)
    print('EventID is ' + response['Entries'][0]['EventId'])
except Exception as e:
    print(e)
```

</details>

### Process

1. EventBrdige에서 **Event Buses** 생성
2. EventBrdige **Rule**에서 1번에서 만들어진 대기열의 event bus를 지정하고 Rule 생성 클릭
   1. **Event Pattern** 정의를 위해서 이벤트에 맞게 JSON 값 편집
   2. **Targets** 설정, ex) Cloudwatch log group 사용 시, `/aws/events/{name}` 과 같이 설정
3. Event buses의 send events 혹은 CLI 명령어 등 기타 이벤트를 send 하며 테스트
   - Target이 SNS일 경우 : SQS의 대기열에서 Send and receive messages의 **Poll for messages** 확인

> 2번 단계에서 Event Pattern이 아닌 Schedule을 선택하면 정규표현식으로 Cron 생성

<br>

## SNS

**SNS**(Publish 역할)와 **SQS**(Subscriber)를 사용해 **pub/sub** 구현하기

### Process

1. SQS에서 대기열 생성
2. SQS에서 만들어진 대기열의 **SNS Subscription에서 SNS의 topic** 지정
3. SNS에서 topic 선택하면, Subscription 목록을 확인 할 수 있음.
4. 3번에서 확인된 Subscription을 선택해 **필터 정책** 설정
5. 대기열 Purge
