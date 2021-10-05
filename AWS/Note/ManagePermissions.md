# IAM

# Cognito

네이티브 애플리케이션 또는 브라우저상에서 돌아가는 JS 프로그램에서는 IAM Role을 이용 할 수 없기에 사용자의 인증 및 인가를 실시하는 완전 관리형 서비스

- Cognito Identity : 인증 및 인가 서비스
  - User Pools : 독자적인 Identity Provider 서비스
  - Federated Identities : 인증 완료 사용자에게 AWS 서비스 이용 및 허가를 부여하는 서비스
- Cognito Sync : 디바이스 간 데이터 동기화 서비스

## Cognito Identity를 이용한 인증과 인가 절차

1. 로그인 <br>
   이용자는 Identity Provider에 로그인, 인증에 성공하면 Identity Provider는 이용자에게 인증 토큰을 반환
2. 인증 토큰 <br>
   이용자는 인증 토큰을 Federated Identities에 전달하고 AWS 리소스 작업 허가를 요청
3. 유효성 문의 <br>
   요청을 받은 Federated Identities는 발행처인 Identity Provider에 인증 토큰의 유효성을 문의하고,
   유효하면 Federated Identities 내에 인증 토큰을 보관
4. 임시 키의 반납 <br>
   Federated Identities는 사전에 등록된 IAM 역할과 동등한 권한이 있는 Temporary Credentials를 취득하고 이용자에게 반납.
   이용자는 이 임시 키를 이용해 AWS 리소스 작업을 함.

## User Pools

사용자의 등록이나 로그인, 로그아웃 등의 인증기구를 제공하는 완전 관리형 ID 프로바이더 서비스
133
