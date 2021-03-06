provider "aws" {
  version = "~> 2.25"
  region  = var.aws_region
  profile = var.aws_profile
}

// Dynamodb for tfstate lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "TerraformStateLock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

// 로그 저장용 버킷
resource "aws_s3_bucket" "logs" {
  bucket = "heuristicwave-tf-log"
  acl    = "log-delivery-write"
}

// S3 bucket for backend
resource "aws_s3_bucket" "terraform-state" {
  bucket = "heuristicwave-tfstate"
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name = "terraform state"
  }
  logging {
    target_bucket = aws_s3_bucket.logs.id
    target_prefix = "log/"
  }
  lifecycle {
    prevent_destroy = true
  }
}

// Terraform Config
terraform {
  required_version = "~>0.12"
  backend "s3" {
    bucket     = "heuristicwave-tfstate"
    key        = "tf/CodePipeline/ECR/terraform.tfstate"
    region     = "ap-northeast-2"
    encrypt    = true
    lock_table = "TerraformStateLock"
    acl        = "bucket-owner-full-control"
  }
}
