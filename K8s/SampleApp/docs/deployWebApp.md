## 웹 어플리케이션 배포하기

### backend 배포 (flask, express)

1. `flask-deployment.yaml` 의 image URL 주소 변경

   작업 환경 변경 후 매니페스트 배포

   ```shell
   cd ../manifests
   kubectl apply -f flask-deployment.yaml
   kubectl apply -f flask-service.yaml
   kubectl apply -f nodejs-deployment.yaml
   kubectl apply -f nodejs-service.yaml
   kubectl apply -f ingress.yaml
   ```

2. 수행 결과 웹 브라우저에서 확인

   **flask backend**

   ```shell
   echo http://$(kubectl get ingress/backend-ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')/contents/aws
   ```

   **express backend**

   ```shell
   echo http://$(kubectl get ingress/backend-ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')/contents/aws
   ```

<br>

### frontend 배포 (react)

1. 소스코드 URL 교체

   `amazon-eks-frontend/src` 위치로 이동해 `App.js` 의 44 Line URL을 아래 명령어로 조회하여 나온 값으로 교체

   ```shell
   echo http://$(kubectl get ingress/backend-ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')/contents/'${search}'
   ```

   `amazon-eks-frontend/src/page` 위치로 이동해 `UpperPage.js` 의 33 Line URL 아래 주소로 교체

   ```shell
   echo http://$(kubectl get ingress/backend-ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')/services/all
   ```

2. 소스코드 빌드 후, ECR Push

   `amazon-eks-frontend` 위치로 이동해 변경된 소스코드 빌드

   ```shell
   npm install && npm run build
   ```

   > `npm install` 이후, severity vulnerability가 나오는 경우 `npm audit fix`, `npm run build` 차례로 수행

   사전에 생성한 ECR의 **view push commands** 를 참고해 push

3. manifests 폴더 안 `frontend-deployment.yaml` 의 image URL 주소 변경

4. Manifest 배포 후

   ```shell
   kubectl apply -f frontend-deployment.yaml
   kubectl apply -f frontend-service.yaml
   kubectl apply -f ingress.yaml
   ```

5. 웹 브라우저에서 frontend 확인

   ```shell
   echo http://$(kubectl get ingress/backend-ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')
   ```
