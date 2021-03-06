#### store custom docker image in registry

```
gcloud projects create PROJECTID --name=PROJECTNAME

Dockerfile:
FROM nginx
COPY index.html /usr/share/nginx/html/index.html

docker build -t mynginx1:tag1 .
gcloud auth configure-docker
docker tag mynginx1:tag1 gcr.io/PROJECTID/mynginx1:tag1
docker push gcr.io/PROJECTID/mynginx1:tag1
https://gcr.io/PROJECTID/mynginx1

```

#### connect to cluster in project after creation
```
gcloud auth login
gcloud config set project aaaa-123456
gcloud container clusters get-credentials cluster1
kubectl get po
```

#### create public Loadbalancer in Kubernetes 
```
kubectl expose deployment nginx-1 --type=LoadBalancer --port 80 --target-port 80
```

#### list instances and ssh into them
```
gcloud compute instances list
gcloud compute --project "myproject" ssh --zone "us-central1-f" "gke-some-instance"
```
