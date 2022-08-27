## Versioning, Releases, and Rollouts

**Best Practices**

1. 애플리케이션 전체에 시멘틱 버전을 적용하세요. 컨테이너의 버전과 파드 배포 버전은 다릅니다.
   컨테이너와 애플리케이션 자체도 독립적인 라이프사이클을 가집니다.
2. 디플로이먼트 메타데이터 내의 릴리스와 릴리스 버전/숫자 레이블을 사용해 CI/CD 파이프라인 릴리스를 추적하세요.
3. 디플로이먼트 패키지 서비스로 헬름을 사용하고 있다면, 헬름 차트와 함께 롤백이 되거나 업그레이드될 서비스를 함께 묶을 수 있도록 주의하세요.
4. 조직의 운영 흐름에 맞는 릴리스 명명법(nomenclature)을 합의하세요. `stable, canary, alpha` 만으로도 충분합니다.

## Worldwide Application Distribution and Staging
