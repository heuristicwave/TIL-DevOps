## Container Insights

1. `amazon-cloudwatch` 라는 네임스페이스를 생성하고 목록을 조회해 확인합니다.

   ```shell
   kubectl create ns amazon-cloudwatch
   kubectl get ns
   ```

2. 설정 값들을 한줄씩 복사 붙여넣기 작업으로 명명합니다.

   ```shell
   ClusterName=eks-demo
   RegionName=ap-northeast-2
   FluentBitHttpPort='2020'
   FluentBitReadFromHead='Off'
   [[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
   [[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
   ```

3. 다음 명령어로 설정한 값들을 활용해 yaml 파일을 배포 합니다.

   ```shell
   curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${ClusterName}'/;s/{{region_name}}/'${RegionName}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f -
   ```

4. 아래 명령어를 통해 정상적으로 설치되었는지 확인 합니다.

   ```shell
   # 각 노드의 갯수만큼 나옴
   kubectl get po -n amazon-cloudwatch
   # 2개의 Daemonset이 출력
   kubectl get daemonsets -n amazon-cloudwatch
   ```
