## S3

S3.tf

```terraform
provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_s3_bucket" "main" {
  bucket = "unique-name"

  tags = {
    Name = "unique-name"
  }
}
```

> **S3 Test**
>
> ```shell
> aws s3 cp {file name} s3://{bucket-name}/$PATH		# upload
> aws s3 cp s3://{bucket-name}/$PATH/{file name} .	# download	
> ```

<br>

<br>

## IAM

### User 기본 생성

```terraform
provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_iam_user" "your_user_name" {
  name = "name.usr"
}
```

### Group 기본 생성

```terraform
provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_iam_group" "devops_group" {
  name = "devops"
}


# IAM User를 IAM Group에 등록
resource "aws_iam_group_membership" "devops" {
  name = aws_iam_group.devops_group.name

  users = [
    aws_iam_user.your_user_name.name
  ]

  group = aws_iam_group.devops_group.name
}
```



<br>

### IAM Policy Structure

```json
{
    "Statement":[
        {
            "Effect":"effect",
            "Action":"action",
            "Resource":"arn",
            "Condition":{
                "condition":{
                    "key":"value"
                }
            }
        }
    ]
}
```



- Effect : "Allow" 또는 "Deny"일 수 있습니다. 기본적으로 IAM 사용자에게는 리소스 및 API 작업을 사용할 권한이 없으므로 모든 요청이 거부됩니다.
- Action : action은 권한을 부여하거나 거부할 특정 API 작업입니다.
- Resource : 작업의 영향을 받는 리소스입니다. Amazon 리소스 이름(ARN)을 사용하거나 명령문이 모든 리소스에 적용됨을 표시하는 와일드카드(*)를 사용합니다.
- 선택 사항으로서 정책이 적용되는 시점을 제어하는 데 사용할 수 있습니다. 다양한 조건을 넣어 권한을 부여 할 수 있습니다.

