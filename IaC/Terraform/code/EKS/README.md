EKS getting started - [📍Origin Repo📍](https://github.com/hashicorp/terraform-provider-aws/tree/main/examples/eks-getting-started)

# EKS Getting Started Guide Configuration

This is the full configuration from https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html

See that guide for additional information.

NOTE: This full configuration utilizes the [Terraform http provider](https://www.terraform.io/docs/providers/http/index.html) to call out to icanhazip.com to determine your local workstation external IP for easily configuring EC2 Security Group access to the Kubernetes servers. Feel free to replace this as necessary.

### 구축방법

```shell
terraform init
terraform plan
terraform apply
```

### kubectl 설정 하기

1. `terraform output`으로 `.kube`의 `config` 수정

```shell
mkdir ~/.kube/
terraform output kubeconfig > ~/.kube/config
```

2. awscli로 `.kube`의 `config` 수정 (리전 생략 가능)

```shell
aws eks --region <region-code> update-kubeconfig --name <cluster_name>
```

`kubectl version`으로 확인 하기

### Trouble Shooting

- [kubectl server 인증 문제](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)

<br>

---

Reference : [dveamer 블로그](http://dveamer.github.io/backend/TerrafromAwsEks.html)
