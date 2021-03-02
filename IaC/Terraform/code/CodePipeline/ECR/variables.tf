variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-northeast-2"
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "aws_ecr" {
  description = "AWS ECR "
}

variable "container_name" {
  description = "Container Name"
  default     = "my-container"
}

# Source repo name and branch
variable "source_repo_name" {
  description = "Source repo name"
  type        = string
}

variable "source_repo_branch" {
  description = "Source repo branch"
  type        = string
}

# Image repo name for ECR
variable "image_repo_name" {
  description = "Image repo name"
  type        = string
}
