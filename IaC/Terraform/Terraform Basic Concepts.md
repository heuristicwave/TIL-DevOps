## Terraform 기본 개념

- resource : 실제로 생성할 인프라 자원을 의미
- provider : Terraform으로 정의할 Infrastructure Provider
- output : 인프라를 프로비저닝 한 후에 생성된 자원을 `output`으로 뽑을 수 있습니다. 이 부분은 이후에 `remote state`에서 활용할 수 있습니다.
- backend : terraform의 상태를 저장할 공간을 지정하는 부분, 현재 배포된 최신 상태를 외부에 저장하기 때문에 다른 사람과의 협업이 가능합니다. 가장 대표적으로는 aws s3
- module : 일종의 함수, 모듈을 사용해 변수만 바꿔 동일한 리소스를 손쉽게 생성
- remote state : 스테이트가 다른 서로 다른 코드에서 다른 state에 저장된  variable들을 가져오고 싶을 때, 다른 서비스에서 참조 할 수 있다.

<br>

## Terraform 작동 원리

테라폼의 3가지 형상

1. Local 코드 : 현재 개발자가 작성/수정하고 있는 코드
2. AWS 실제 인프라 : 실제로 AWS에 배포되어 있는 인프라
3. Backend에 저장된 상태 : 가장 최근에 배포한 테라폼 코드 형상



2 & 3번 이 서로 100% 일치하게 만드는 것이 중요한데, 이를 위해 import, state 등의 명령어를 제공

인프라 정의는 Local 코드에서 시작함. 개발자는 로컬에서 테라폼 코드를 정의한 후에 해당 코드를 실제 인프라로프로비전함. 이때, backend를 구성하여 최신 코드를 저장.

<br>

## Terraform init

- 지정한 backend에 상태 저장을 위한 `.tfstate` 파일을 생성합니다. 여기에는 가장 마지막 테라폼 내역이 저장됩니다.
- init 작업을 완료하면, local에는 `.tfstate` 에 정의된 내용을 담은 `.terraform` 파일이 생성
- 기존에 다른 개발자가 이미 `.tfstate`에 인프라를 정의해 놓은 것이 있다면, 다른 개발자는 init 작업을 통해서 local에 sync를 맞출 수 있음.

<br>

## Terraform plan

- 정의한 코드가 어떤 인프라를 만들지 미리 예측 결과를 보여줌. 단, plan을 한 내용에 에러가 없다고 하더라도, 실제 적용되었을때는 에러가 발생가능 함
- **plan 명령어는 어떠한 형상에도 변화를 주지 않음**

<br>

## Terraform apply

- 실제 인프라 배포 명령어. apply 완료 후, 실제 인프라가 생성되고 작업결과가 backend의 `.tfstate` 파일에 저장됨

<br>

---

위 자료는 `송주영`님의 강의를 듣고 정리한 자료입니다.
