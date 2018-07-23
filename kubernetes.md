#### quick start minikube
```
minikube start --vm-driver=virtualbox
kubectl run trickkiste1 --image=nginx --port=80
kubectl proxy    (or kubectl proxy --address='myIP' )
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
