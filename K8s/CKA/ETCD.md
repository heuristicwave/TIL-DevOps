



`/data/etcd-snapshot.db`



## ETCD [Backup](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster) & [Restore](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#restoring-an-etcd-cluster)

### Backup

1. 현재 위치 파악 후 (`kubectl config current-context` ) ,작업 대상으로 SSH로 연결 

2. 아래 명령어로 스냅샷 (일반 유저는 + `sudo`)

   ```shell
   ETCDCTL_API=3 etcdctl \
   	--endpoints=https://127.0.0.1:2379 \
     --cacert=<trusted-ca-file> \
     --cert=<cert-file> \
     --key=<key-file> \
     snapshot save <backup-file-location>
   ```

3. `Snapshot saved at <backup-file-location> ` 메시지 확인



### Restore

1. 아래 명령어로 복구 (data-dir-location : `/var/lib/etcd-previous`, 일반 유저는 + `sudo`)

   ```shell
   ETCDCTL_API=3 etcdctl \
   	--data-dir <data-dir-location> \
   	snapshot restore snapshotdb
   ```

2. 현재 동작중인 etcd pod에게 복구한 저장소 위치 전달 하기 위해 `etcd.yaml` 수정  (`/etc/kubernetes/manifests`)

   - `hostPath:` 의 Config 를 새로운 저장소 위치로 수정

3. `kubectl get pod` 로 바뀐 etcd pod 확인 



### 기타 명령어



기타 필요한 명령어

- 현재 운영중인 etcd 파악 :  `sudo tree /var/lib/etcd`
- `etcdctl version`