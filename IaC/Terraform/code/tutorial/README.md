# Terraform Deep Dive

tutorial에 사용되는 `*.tfvars`

```
vpc_cidr_block    = "10.0.0.0/16"
subnet_cidr_block = "10.0.0.0/24"
avail_zone        = "ap-northeast-1a"
env_prefix        = "dev"
my_ip             = {Your IP}
instance_type     = "t2.micro"
image_name        = "amzn2-ami-hvm-*-x86_64-gp2"
```

<br>

### Object 활용하기

```terraform
# variables.tf
variable "cidr_blocks" {
  type = list(object({
    cidr_block = string
    name			 = string
  }))
}

# terraform.tfvars
cidr_blocks = [
	{cide_block = "10.0.0.0/16", name = "vpc"},
  {cide_block = "10.0.0.0/24", name = "subnet"}
]

# main.tf
resource "aws_vpc" "my-vpc" {
	cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
  	Name: var.cidr_blocks[0].name
  }
}
```

<br>

### Resource VS Data Resource

- **Resource** : describes one or more infrastructure objects, such as networks, compute, or higher-level components

- **Data Resource** : defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions. (코드로 생성되지 않은 리소스를 쿼리하여 사용 가능한 리소스를 파악 => 더 유연한 코드)

  ```terraform
  data "aws_vpc" "existing_vpc" {
  	default = true
  }

  resource "aws_subnet" "dev-subnet-2" {
  	vpc_id = data.aws_vpc.existing_vpc.id
  }
  ```

<br>

## Modules

[모듈화 적용 전](https://github.com/heuristicwave/TIL-DevOps/commit/f1a473870a8772b1955e50df02aa0d59e68b4e15#diff-65b0bc5c3ab652135b86cb73c39967f6a4f9da98ee48eac716c1ca736ab3e6e1)

<br>

### Root에서 child module resource 참조하기

> 📍Tip 테라폼의 모듈을 프로그래밍 언어의 함수처럼 생각 <br>
>
> - module == 함수
> - 모듈에 주입하는 value == 함수 input params
> - Output == 함수에서 return
> - 모듈 외부에서 리소스 참조 == 함수 return 값 활용

1. Child Modules에서 Output 작성

   ```terraform
   output "subnet" {
     value = aws_subnet.myapp-subnet-1
   }
   ```

2. module사용을 위한 input value 주입

   ```terraform
   module "myapp-subnet" {
     source = "./modules/subnet"

     # values are passed to child module as arguments
     subnet_cidr_block = var.subnet_cidr_block
     avail_zone = var.avail_zone
     env_prefix = var.env_prefix
     vpc_id = aws_vpc.myapp-vpc.id
     default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
   }
   ```

3. Root에 위치한 코드에서 참조

   ```terraform
   resource "aws_instance" "myapp-server" {
     # Other Config Skip

     # module.{module-NAME}.{output-Name}
     subnet_id              = module.myapp-subnet.subnet.id

     # Other Config Skip
   }
   ```

<br>

### 각각 다른 환경 변수 적용하기

`terraform-dev.tfvars`, `terraform-staging.tfvars`, `terraform-prod.tfvars` 3개의 운영환경 정의

```sh
$ terraform apply -var-file terraform-dev.tfvars
```

<br>

### 테라폼으로 key pair 생성하기

Public Key 생성

```sh
$ ssh-keygen
$ cat ~/.ssh/id_rsa.pub
```

Terraform Config 정의

```terraform
# main.tf
resource "aws_key_pair" "ssh-key" {
	key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "my-server" {
  # Other Config Skip
  key_name = aws_key_pair.ssh-key.key_name
}

# var.tf
variable public_key_location {}

# terraform.tfvars
public_key_location = "~/.ssh/id_rsa.pub"
```

<br>

### user_data VS remote-exec

`user_data` : passing data to AWS

`remote-exec` : connect via ssh using Terraform

🔌 `remote-exec` 로 프로비저닝 하기

```terraform
connection {
  type = "ssh"
  host = self.public_ip
  user = "ec2-user"
  private_key = file(var.private_key_location)
}

provisioner "remote-exec" {
  inline = [
    "export ENV=dev",
    "mkdir newdir"
  ]
}
```

위 **provisioner** 부분의 **inline**을 아래와 같은 방법으로 외부에서 **file을 주입**할 수도 있다.

```terraform
provisioner "file" {
	source 			= "entry-script.sh"
	destination = "/home/ec2-user/entry-script-on-ec2.sh"
}

provisioner "remote-exec" {
  script = file("entry-script-on-ec2.sh")
}
```

> 위 코드 블럭을 재귀 형태로 한번더 정의 하면 다른 서버를 프로비저닝 할 수 있다.
>
> ```terraform
> provisioner "file" {
> 	source 			= "entry-script.sh"
> 	destination = "/home/ec2-user/entry-script-on-other-ec2.sh"
>
>     connection {
>       type = "ssh"
>       host = otherserver.public_ip
>       user = "ec2-user"
>       private_key = file(var.private_key_location)
>     }
> }
> ```

<br>

**local-exec**

```terraform
provisioner "local-exec" {
    command = "echo ${self.public_ip} > output.txt"
}
```

위와 같은 방법들로 terraform은 Provisioner 를 제공하지만 추천하지는 않는다.

> ["We do not recommend using provisioners for any of the use-cases described in the following sections."](https://www.terraform.io/docs/language/resources/provisioners/syntax.html)
>
> - Breaks idempotency(멱등성) concept
> - Terraform doesn't know what you execute

<br>

## Other useful commands

```sh
$ terraform state show aws_vpc.myapp-vpc
```
