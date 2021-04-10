# ECR CodePipeline(CodeCommit, Codebuild) with Terraform

<br>

### ![Resource Graph](./graph.svg)

<br>

### Sample `terraform.tfvars`

```shell
aws_region="ap-northeast-2"
aws_ecr="my-app"
aws_profile="default"
source_repo_name="my-app"
source_repo_branch="master"
image_repo_name="my-app"
```

<br>

## Set up repo

CodeCommit의 Repo 활용법은 아래 2가지 방법이 있다

`terraform output`을 활용해 **export 환경 변수** 지정

```shell
export tf_source_repo_clone_url_http=$(terraform output source_repo_clone_url_http)
echo $tf_source_repo_clone_url_http	# 확인
```

<br>

### 1. 로컬에 위치한 코드를 CodeCommit에 push하기 (원격저장소가 비어있음)

로컬의 빈공간에서 CodeCommit Repo 사용을 위한 git remote 지정

```shell
git init
git remote add origin $tf_source_repo_clone_url_http
git remote -v   # 원격 저장소 확인
```

코드를 작성하고 CodeCommit에 Push하기

```shell
git add .
git commit -m "First commit"
git status
git push origin # master branch로 push

git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
```

### 2. 로컬에 원격저장소의 코드를 clone하기 (원격저장소가 비어있지 않음)

```shell
git clone $tf_source_repo_clone_url_http
```

<br>

---

Reference : [devops-ecs-fargate workshop](https://devops-ecs-fargate.workshop.aws/en/1-introduction.html)
