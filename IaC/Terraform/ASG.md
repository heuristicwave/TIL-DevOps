## ASG

ASG는 시작 구성 설정을 위해 **lifecycle** 변수가 필요하다.

```terraform
lifecycle {
	create_before_destroy = true
}
```

