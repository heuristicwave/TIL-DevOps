## Advanced Scheduling Techniques

### Node Selector

키/값 레이블 셀럭터를 사용해 특정 노드에 파드를 스케줄링하는 가장 간단한 방식.

```shell
kubectl label node <node_name> key=value
```

### Taints and Tolerations

파드가 스케줄링되는 것을 거절하기 위해 노드에 톨러레이션과 함께 사용

```shell
# 설정
kubectl taint nodes node1 key1=value1:NoSchedule
# 확인
kubectl describe nodes node01 | grep -i taint
# 제거
kubectl taint nodes node1 key1=value1:NoSchedule-
```

사용 예시

- 특수한 하드웨어가 있을 경우, 전용 노드 리소스

- 성능이 낮은 노드 회피

#### Taints Effect (Type)

- NoSchedule : 톨러레이션이 일치하지 않는 파드가 스케줄링되는 것을 막는 강한 테인트

- PreferNoSchedule : 다른 노드에 스케줄링될 수 없는 파드만 스케줄링

- NoExecute : 노드에 이미 실행 중인 파드를 evict

- NodeCondition : 특정 조건을 만족시키는 노드를 테인트

---

위 내용은 `Kubernetes Best Practices - Brendan Burns, Eddie Villalba`를 학습하고 정리한 내용입니다.
