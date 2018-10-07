#### store custom docker image in registry

```

Dockerfile:
FROM nginx
COPY index.html /usr/share/nginx/html/index.html

docker build -t mynginx1:tag1 .
gcloud auth configure-docker
docker tag mynginx1:tag1 gcr.io/PROJECTNAME/mynginx1:tag1
docker push gcr.io/PROJECTNAME/mynginx1:tag1
https://gcr.io/PROJECTNAME/mynginx1

```
