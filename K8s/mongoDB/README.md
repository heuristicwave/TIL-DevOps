## 🎞 동영상 강의

[Complete Application Deployment using Kubernetes Components](https://youtu.be/EQNO_kM96Mo)

<br>

### MongoDB k8s Architecture

![Architecture](../../images/mongo_architecture.png)

<br>

## Commands

### Get encoded string

```shell
$ echo -n 'username' | base64
$ echo -n 'password' | base64
```

### kubectl apply commands in order

    kubectl apply -f mongo-secret.yaml
    kubectl apply -f mongo.yaml
    kubectl apply -f mongo-configmap.yaml
    kubectl apply -f mongo-express.yaml

### kubectl get commands

    kubectl get pod
    kubectl get pod --watch
    kubectl get pod -o wide
    kubectl get service
    kubectl get secret
    kubectl get all | grep mongodb

### kubectl debugging commands

    kubectl describe pod mongodb-deployment-xxxxxx
    kubectl describe service mongodb-service
    kubectl logs mongo-express-xxxxxx

### give a URL to external service in minikube

    minikube service mongo-express-service
