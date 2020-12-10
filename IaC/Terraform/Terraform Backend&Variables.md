##  Terraform Backend

Terraform “[Backend](https://www.terraform.io/docs/backends/index.html)” 는 Terraform의 state file을 어디에 저장을 하고, 가져올지에 대한 설정. 기본적으로는는 로컬 스토리지에 저장을 하지만, 설정에 따라서 s3, consul, etcd 등 다양한 “[Backend type](https://www.terraform.io/docs/backends/types/index.html)“을 사용할 수 있다.

> S3과 DynamoDB를 사용할 경우
>
> S3는 저장소 역할을 하고 DynamoDB는 여러명의 사용자가 함께 테라폼 코드를 작성할 경우 중복 수정하는것을 막기 위해서 lock기능을 제공

<br>

### Terraform Backend 를 사용하는 이유?

- Locking : 인프라를 변경한다는 것은 굉장히 민감한 작업이 될 수 있기에, 원격 저장소를 사용함으로써 동시에 같은 state를 접근하는 것을 막아 의도치 않은 변경을 방지
- Backup : 로컬 스토리지에 저장한다는 것은 유실의 가능성을 내포해, S3와 같은 원격 저장소를 사용해 state 파일의 유실을 방지

<br>

## Terraform Variables

Terraform 은 HCL Syntax를 가진 언어. 언어적 특성을 가지고 있기 때문에 당연히 변수를 정의하고 주입해서 사용가능



선언 : variables.tf

```terraform
variable "aws_region" {
  description = "region_for_aws."
}
```



주입 : terraform.tfvars 

```terraform
aws_region = "ap-northeast-2"
```



사용 : provider.tf           

```terraform
provider "aws" {
  region = var.aws_region
}
```





