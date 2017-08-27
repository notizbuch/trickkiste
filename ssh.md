## ssh

```
    ssh public key authentication

    ssh-keygen -t rsa
    creates: ~/.ssh/id_rsa = private key and ~/.ssh/id_rsa.pub = public key
    put the public key into the ~/.ssh/authorized_keys2 file on the host (it will allow to authenticate using the private key now)
    permissions of must be authorized_keys must be 600:
    -bash-3.2$ ls -l ~/.ssh/authorized_keys
    -rw------- 1 user1 group1 381 Jan 01 13:01 .ssh/authorized_keys

    ssh port forwarding

    ssh -L localport:remotecomputer:remoteport user1@remotesshserver
    -> when connecting to localhost:localport it gets forwarded to remotecomputer:remoteport through the connection to remotesshserver
    multiple forwards example:
    ssh -L 101:remotecomputer1:80 -L 102:remotecomputer2:80 -L 103:remotecomputer3:80 user1@remotesshserver

    in order to connect from socket on remotesshserver(port 12345) to port 54321 on the ssh-client-machine:
    ssh -R 12345:localhost:54321 user1@remotesshserver

    setting up ssh server on basic debian system

    sshd-generate ; update-rc.d -f ssh defaults 
```

