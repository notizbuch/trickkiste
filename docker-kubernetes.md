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
#### kubernetes as mysql client
```
kubectl config use-context wordpress

kubectl create -f mysql-connect.yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql-tmp1
spec:
  containers:
  - name: mysql
    image: mysql
    env:
    - name: MYSQL_ALLOW_EMPTY_PASSWORD
      value: "1"

kubectl exec -it mysql-tmp1 -- /usr/bin/mysql -h host1 -uUser1 -pPassword1 
```

#### playing around with services and ingress using examples from the k8s site
```
cat >echoserver-namespace.yaml<<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: echoserver
EOF

cat >echoserver-deployment.yaml<<EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: echoserver
  namespace: echoserver
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: echoserver
    spec:
      containers:
      - image: gcr.io/google_containers/echoserver:1.4
        imagePullPolicy: Always
        name: echoserver
        ports:
        - containerPort: 8080
EOF

cat >echoserver-service.yaml<<EOF
apiVersion: v1
kind: Service
metadata:
  name: echoserver
  namespace: echoserver
spec:
  ports:
    - port: 30123
      targetPort: 8080
      protocol: TCP
  selector:
    app: echoserver
EOF

cat >echoserver-ingress-normal.yaml<<EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: echoserver
  namespace: echoserver
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
    - host: echoserver.example.com
      http:
        paths:
          - path: /
            backend:
              serviceName: echoserver
              servicePort: 8080
EOF


kubectl expose deployment echoserver --type=NodePort --name=nodeporttest
```


#### K8s nginx with Ingress
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx1
  template:
    metadata:
      labels:
        app: nginx1
    spec:
      containers:
      - name: nginx1
        image: nginx:1.7.9

---

apiVersion: v1
kind: Service
metadata:
  name: nginx1-service
spec:
  ports:
    - port: 30124
      targetPort: 80
      protocol: TCP
  selector:
    app: nginx1

---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nginx1
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
    - host: nginx1.example.com
      http:
        paths:
          - path: /
            backend:
              serviceName: nginx1-service
              servicePort: 30124
```

#### RBAC assign a role 
```
kubectl create rolebinding blah --clusterrole=admin --user=users:myuser 

e.g. when GKE sets up dashboard and complains lack of permissions 
kubectl create rolebinding blah2 --clusterrole=admin --user=system:serviceaccount:kube-system:kubernetes-dashboard
kubectl create clusterrolebinding blah3 --clusterrole=cluster-admin --user=system:serviceaccount:kube-system:kubernetes-dashboard
```
