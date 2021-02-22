EKS getting started - [📍Origin Repo📍](https://github.com/hashicorp/terraform-provider-aws/tree/main/examples/eks-getting-started)

# EKS Getting Started Guide Configuration

This is the full configuration from https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html

See that guide for additional information.

NOTE: This full configuration utilizes the [Terraform http provider](https://www.terraform.io/docs/providers/http/index.html) to call out to icanhazip.com to determine your local workstation external IP for easily configuring EC2 Security Group access to the Kubernetes servers. Feel free to replace this as necessary.

### Trouble Shooting

- [kubectl server 인증 문제](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)

