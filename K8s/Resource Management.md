## Advanced Scheduling Techniques

### [Pod Affinity and Anti-Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity)

#### Set Node Affinity

#### [_Set-based_ requirement](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#set-based-requirement) : `in`, `notin`, `exists`

```yaml
# spec 하위에 기재
affinity:
  nodeAffinity:
    # 같은 영역 위에 포드 배치
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: color
              operator: In
              values:
                - blue # blue label이 명세된 노드에 배
```

### Node Selector

키/값 레이블 셀럭터를 사용해 특정 노드에 파드를 스케줄링하는 가장 간단한 방식.

```shell
kubectl label node <node_name> key=value
```

#### Labels

Label 정보 얻기

```shell
kubectl describe node <node name>
kubectl get node <node name> --show-labels
```

Label 부여하기

```shell
kubectl label node <node name> key=value
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



A toleration "matches" a taint if the keys are the same and the effects are the same, and:

- the `operator` is `Exists` (in which case no `value` should be specified), or
- the `operator` is `Equal` and the `value`s are equal.

---

참고자료 : `Kubernetes Best Practices - Brendan Burns, Eddie Villalba`
