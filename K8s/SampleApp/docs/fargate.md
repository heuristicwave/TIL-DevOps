## Fargate로 배포하기

1. 아래 명령어로 profile 프로비저닝 (리전, 클러스터 이름 확인!!)

   ```shell
   eksctl create fargateprofile -f eks-demo-fargate-profile.yaml
   ```

   > Private 서브넷에서만 fargate 프로비저닝 가능! (원래 둘다 되야 하는데, eks fargate는 안되는 듯)

2. 기존 front-end 내리기

   ```shell
   kubectl delete -f frontend-deployment.yaml
   ```

3. manifests 폴더 안 `frontend-deployment.yaml` 의 다음과 같이 변경

   ```yaml
   cat <<EOF> frontend-deployment.yaml
   ---
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: demo-frontend
     namespace: default
   spec:
     replicas: 3
     selector:
       matchLabels:
         app: frontend-fargate
     template:
       metadata:
         labels:
           app: frontend-fargate
       spec:
         containers:
           - name: demo-frontend
             image: $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/demo-frontend:latest
             imagePullPolicy: Always
             ports:
               - containerPort: 80
   EOF
   ```

4. `frontend-service.yaml` 도 수정

   ```yaml
   cat <<EOF> frontend-service.yaml
   ---
   apiVersion: v1
   kind: Service
   metadata:
   name: demo-frontend
   annotations:
      alb.ingress.kubernetes.io/healthcheck-path: "/"
   spec:
   selector:
      app: frontend-fargate
   type: NodePort
   ports:
      - protocol: TCP
         port: 80
         targetPort: 80
   EOF
   ```

5. Manifest 재배포

   ```shell
   kubectl apply -f frontend-deployment.yaml
   kubectl apply -f frontend-service.yaml
   ```

6. 프로비저닝 확인 (fargate)

   ```shell
   kubectl get po -o wide
   ```
