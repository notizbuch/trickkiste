#### quick start minikube
```
minikube start --vm-driver=virtualbox
kubectl run trickkiste1 --image=nginx --port=80
kubectl proxy    (or kubectl proxy --address='myIP' ; now kubernetes Dashboard is at http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/#!/overview?namespace=default )
kubectl get pods
curl http://localhost:8001/api/v1/namespaces/default/pods/trickkiste1-PODABCDEF-PODGHJKL/proxy/
kubectl expose deployment/trickkiste1 --type="NodePort" --port 80
kubectl get services
kubectl exec -ti trickkiste1-ABCDEF-GHJKL bash
echo hello world trickkiste > /usr/share/nginx/html/index.html
curl $(minikube ip):34567
kubectl delete services X
kubectl delete deployment Y
minikube stop
minikube delete
```


#### getting started
```
cat << EOF > Dockerfile
FROM nginx
RUN echo hello notizbuch > /usr/share/nginx/html/index.html
EOF

eval $(minikube docker-env)
docker build -t image01:1.0 .

cat << EOF > deployment01.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment01
spec:
  selector:
    matchLabels:
      app: appname01
  replicas: 1
  template:
    metadata:
      labels:
        app: appname01
    spec:
      containers:
      - name: httpfromimage01
        imagePullPolicy: Never
        image: image01:1.0
        ports:
        - containerPort: 80
EOF

kubectl apply -f deployment01.yaml

kubectl expose deployment deployment01 --type=NodePort

curl $(minikube ip):32244
hello notizbuch
```

#### enable containers to interact via DNS
```
docker network create mynetwork
docker run --name alpine1 --network mynetwork -ti alpine /bin/sh
```
now ping alpine1 works from another container.

#### enable pods to interact via DNS
```
kubectl run mynginx1 --image=nginx

kubectl run myalp4 -ti --image=alpine /bin/sh
ping mynginx1
ping: bad address 'mynginx1'

kubectl expose deployment mynginx1 --port=80 --name=mynginx1 --type=ClusterIP

kubectl run myalp5 -ti --image=alpine /bin/sh
apk add --no-cache curl
curl mynginx1
WORKS
```

#### Namespaces - if no output then probably wrong namespace
```
kubectl get namespaces
kubectl get all --all-namespaces
kubectl config use-context mytest01
context has to be in .kube/config before.

Create:
kubectl create -f -
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "mytest01",
    "labels": {
      "name": "mytest01"
    }
  }
}

create entry in .kube/config :
kubectl config set-context mytest01 --namespace=mytest01 --cluster=somecluster

Use it:
kubectl config use-context mytest01

Delete:
kubectl delete namespaces mytest01
```

#### port forwarding
```
kubectl port-forward -n NAMESPACE PODNAME PORT
now localhost:PORT will forward to PORT on PODNAME
```

#### docker image as mysql client
```
docker run -it mysql /usr/bin/mysql -h 1.1.1.1 -u user1 -pPassword1 database1
```


