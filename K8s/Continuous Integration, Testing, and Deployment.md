# Continuous Integration, Testing, and Deployment

## Testing

**helm lint**를 통해 차트의 잠재적인 문제를 조사하기 위해 일련의 테스트 수행

## Container Builds

### Multistage Build

하나의 도커파일로 애플리케이션 실행에 필요한 정적 바이너리만 포함하는 최종 이미지 생성

### 배포판이 없는 기본 이미지

불필요한 바이너리와 shell을 이미지에서 제거 (디버거를 붙일 수 없다는 단점 존재)

### 최적화된 기반 이미지

OS 계층에서 불필요한 것을 제거하고 군살을 뺀 이미지. (ex.Alpine Linux)

## Container Image Tagging

이미지를 태그할 때 효과적인 여러 전략

- BuildID : 빌드와 연관된 BuildID를 태그의 일부로 사용해 어떤 빌드에서 만들어졌는지 파악
- BuildSystem-BuildID : 여러 빌드 시스템이 존재하면 BuildID와 함께 적용
- GitHash : 커밋이후 생성 된 해시를 태그에 사용
- GitHash-BuildID

## Deployment Strategies

```YAML
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1         # 한 번에 업데이트할 최대 replica 수
    maxUnavailable: 1   # 롤아웃 중간에 가용하지 않는 최대 레플리카 수
```
