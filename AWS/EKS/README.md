# eksctl로 eks 구축하기

```shell
eksctl create cluster -f eks-demo-cluster.yaml
```

<br>

### 궁금증

iam policy albIngress에 관하여...

`eks-demo-cluster.yaml` 의 `albIngress` config `true`

```yaml
iam:
  withAddonPolicies:
    imageBuilder: true # AWS ECR에 대한 권한 추가
    cloudWatch: true # cloudWatch에 대한 권한 추가
    albIngress: true # albIngress에 대한 권한 추가
    autoScaler: true # auto scaling에 대한 권한 추가
```

eksctl-nodegroup(ec2) role에 (PolicyAWSLoadBalancerController, PolicyAutoScaling) inline 형식으로 들어감

`eks-demo-cluster.yaml` 의 `albIngress` config 삭제

eksctl-nodegroup(ec2) role에 (PolicyAutoScaling) inline 형식으로 들어감
PolicyAWSLoadBalancerController 없어도 추후에 IRSA 작업하면 다 되는데 왜 있는지 모르겠음.

```yaml
iam:
  withAddonPolicies:
    imageBuilder: true # AWS ECR에 대한 권한 추가
    cloudWatch: true # cloudWatch에 대한 권한 추가
    autoScaler: true # auto scaling에 대한 권한 추가
```
