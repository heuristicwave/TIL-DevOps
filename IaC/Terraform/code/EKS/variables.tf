variable "aws_region" {
  default = "ap-northeast-2"
}

variable "cluster-name" {
  default = "terraform-eks-cluster"
  type    = string
}

variable "instance_type" {
  default = ["c5.large"]
}
