#### install expect on debian

```
tar xf expect5.45.3.tar.gz
apt-get -y install tcl tcl-dev
.configure
make
make install
echo /usr/lib/expect5.45.3 >> /etc/ld.so.conf
ldconfig
```

#### example expect script: password login via ssh
```
#!/usr/bin/expect
spawn  ssh root@server1
expect "password:"
send "PASSWORDHERE\n";
interact
```
