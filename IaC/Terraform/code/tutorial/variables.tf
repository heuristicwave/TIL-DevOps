variable "vpc_cidr_block" {

}

variable "subnet_cidr_block" {

}

variable "avail_zone" {

}

variable "env_prefix" {

}

variable "my_ip" {

}

variable "instance_type" {

}

output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}
