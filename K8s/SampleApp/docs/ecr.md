## ECR 생성하고 이미지 올리기

1. ECR 생성

   **flask backend**

   ```shell
   aws ecr create-repository \
   --repository-name demo-flask-backend \
   --image-scanning-configuration scanOnPush=true \
   --region ${AWS_REGION} | jq -r
   ```

   **react frontend**

   ```shell
   aws ecr create-repository \
   --repository-name demo-frontend \
   --image-scanning-configuration scanOnPush=true \
   --region ${AWS_REGION} | jq -r
   ```

2. ecr repository login > 이미지 빌드 > 이미지 태깅 > push

   > 이미지 빌드
   >
   > ```shell
   > cd ./amazon-eks-flask
   > docker build -t demo-flask-backend .
   > ```
