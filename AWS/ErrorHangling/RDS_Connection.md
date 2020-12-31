## RDS 연결 관련 Error

### 연결 확인 Checklist

- [x] 퍼블릭 액세스 허용

- [x] name, user, host 확인 (.env)

  .env는 캐시가 됨으로, 내용을 수정했을 경우 서버를 재기동 해야함

  *PostgreSQL*의 경우에는 초기 DB name을 지정하지 않으면 default는 `postgres`

- [x] 보안그룹 확인

<br>

**배포 환경에 따라 달라지는 dotenv**

- gunicorn 을 활용해 연결 할 경우 

  ```shell
  $ pip uninstall python-dotenv 
  $ pip install dotenv
  ```

- docker + nginx + gunicorn 을 활용해 rds에 연결 할 경우

  ```shell
  $ pip uninstall dotenv
  $ pip install python-dotenv 
  ```

<br>

**해결 하지 못한 error**

도커를 사용하지 않는 환경에서는 에러가 없음

(docker + nginx + gunicorn) + rds 에서 `connections on Unix domain socket  "/var/run/postgresql/.s.PGSQL.5432"?` 를 만날 경우, docker 위에서 rds를 연결할 때 문제가 생기는 것으로 보아, 장고와 postgres를 연결해주는 `psycopg2` 가 의심된다.   

> psycopg2.OperationalError: could not connect to server: No such file or directory web_1    |      Is the server running locally and accepting

