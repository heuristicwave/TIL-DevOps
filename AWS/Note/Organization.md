# Organization

파일 시스템처럼 트리 구조를 이용해 계정 그룹화하여 여러 계정을 효율적으로 관리

주요 기능

- 계정 생성
- 결제 일원 관리
- 서비스 제한 설정 (SCP)

<br>

## SCP

Organization에 연결된 계정에 이용 가능한 AWS 서비스 혹은 특정 작업에 대한 권한을 설정

> 예시
>
> - EC2의 모든 기능의 이용을 허가
> - RDS는 참조 관련 작업만 허가

SCP는 Allowlist("Effect": "Allow"), Blocklist("Effect": "Allow") 으로 정의

> **IAM vs SCP**
>
> IAM 정책 : `Resource`를 설정해 작업 대상까지 지정한 정책 정의
>
> SCP : `Resource`에 `*`로만 지정 가능(특정 리소스 지정 불가능)

<br>

## Best Practice

1. 메인 계정으로 CloudTrail 활성화
2. 메인 계정은 계정 관리 전용으로 하기
3. OU에 SCP를 적용해 권한 제어
4. OU내에서 Allowlist와 BlockList 혼합 하지 않기

<br>

---

Reference : [AWS 시스템 설계와 마이그레이션](http://www.yes24.com/Product/Goods/67031301)
