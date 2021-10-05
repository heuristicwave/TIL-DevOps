# EB

*pipenv를 사용하지 않을 경우 가상환경에서 pip로 대체하여 진행*

<br>

**Download**

```shell
$ pipenv install awsebcli --dev (--skip-lock)
```

**Settings**

1. command `eb init`
2. select region *ex) 10, [ap-northeast-2 : Asia Pacific (Seoul)]*
3. input aws credentials
4. select platform *ex) python 3.7*
5. setting CodeCommit & SSH

<br>

**[Deploying a Django application to Elastic Beanstalk](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-django.html)**

create `.ebextensions` folder

create `django.config` in `.ebextensions` folder

```
# django.config
option_settings:
  aws:elasticbeanstalk:container:python:
    WSGIPath: config/wsgi.py
```

> **사용환경에 따라 맞는 django.config 사용**
>
> WSGIPath: config.wsgi:application

command `eb create <project_name>`

<br>

**Create requirements.txt**

```shell
$ pipenv install pipenv-to-requirements
$ pipenv lock (--pre)
$ pipenv_to_requirements -f
```

위 작업을 마치고 git commit 수행하기

<br>

`eb deploy` 로 배포 후, `eb open` 으로 앱서비스 확인
에러 발생 시,  `eb logs`로 log확인

