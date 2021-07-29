provider "aws" {
  region = "ap-northeast-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs                = [var.avail_zone]
  public_subnets     = [var.subnet_cidr_block]
  public_subnet_tags = { Name = "${var.env_prefix}-subnet-1" }

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-server" {
  source = "./modules/webserver"

  vpc_id = module.vpc.vpc_id

  # Root Variables.tf
  my_ip         = var.my_ip
  env_prefix    = var.env_prefix
  image_name    = var.image_name
  instance_type = var.instance_type
  avail_zone    = var.avail_zone

  # Module
  subnet_id = module.vpc.public_subnets[0]
}
