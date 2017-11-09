#### create ssh honeypot:

```
docker run -it -p 4022:22 golang:1.6 bash -c 'ssh-keygen -f host_key -t rsa -N ""; go get -u github.com/jaksi/sshesame; sshesame -port 22 -listen_address 0.0.0.0'
```
