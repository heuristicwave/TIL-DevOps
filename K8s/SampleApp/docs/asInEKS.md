## Autoscaling Pod & Cluster

### HPA

1. Metrics 서버 아래 명령어로 생성 후, `kubectl get deployment metrics-server -n kube-system` 명령어로 확인

   ```shell
   kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml
   ```

2. 사전에 수행한 `flask deployment.yaml` 파일을 아래와 같이 수정합니다. 해당 작업을 통해, **레플리카를 1**로 설정하고 **필요한 리소스 설정**

   ```yaml
   resources:
     requests:
     	cpu: 250m
     limits:
     	cpu: 500m
   ```

   이후, `kubectl apply -f flask-deployment.yaml` 로 변경 사항 적용

3. `manifests` 하위 `kubectl apply -f flask-hpa.yaml` 을 활용해 hpa를 적용합니다.

   > kubectl로 적용하기  `kubectl autoscale deployment demo-flask-backend --cpu-percent=30 --min=1 --max=5` 

4. 파드의 변화량을 파악하기 위해 다음명령어를 사용합니다. `kubectl get hpa -w`

5. Hpa 를 테스트하기 위해 다음 명령어를 사용합니다. 

   ```shell
   ab -c 200 -n 200 -t 30 http://$(kubectl get ingress/backend-ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')/contents/aws
   ```

<br>

### Cluster Autoscaler

1. 아래 명령어로 오토스케일링 여부를 조회합니다.

   ```shell
   aws autoscaling \
       describe-auto-scaling-groups \
       --query "AutoScalingGroups[? Tags[? (Key=='eks:cluster-name') && Value=='eks-demo']].[AutoScalingGroupName, MinSize, MaxSize,DesiredCapacity]" \
       --output table
   ```

2. `manifests` 의 `cluster-autoscaler-autodiscover.yaml` 파일을 열어 ServiceAccount 부분과 ClusterName 부분을 수정합니다.

3. 다음 명령어를 통회 CA를 적용하고 노드를 확인합니다.

   ```shell
   kubectl apply -f cluster-autoscaler-autodiscover.yaml		# CA 배포
   kubectl get nodes -w	# 워커 노드의 변화량 파악
   ```

4. 다음 명령어로 파드를 배포해 기능이 동작하는지 확인합니다.

   ```shell
   kubectl create deployment autoscaler-demo --image=nginx
   kubectl scale deployment autoscaler-demo --replicas=100
   ```

5. 배포 진행 상태를 다음 명령어로 확인합니다.

   ```shell
   kubectl get deployment autoscaler-demo --watch
   ```

   

