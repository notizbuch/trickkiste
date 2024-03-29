#### install expect on debian

```
tar xf expect5.45.3.tar.gz
apt-get -y install tcl tcl-dev
./configure
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

#### connect to HTTPS site using openssl, send Cookies

```
#!/usr/bin/expect
spawn /usr/bin/openssl s_client -connect www.example.com:443 -crlf
set spawn_id_openssl01 $spawn_id
expect -i $spawn_id "Verify return code: 0 (ok)\r\n---"
send -i $spawn_id "GET / HTTP/1.1\n"
send -i $spawn_id "Host: www.example.com\n"
send -i $spawn_id "Cookie: mycookie01=\"value01\"; mycookie02=value02; mycookie03=value03\n"
send -i $spawn_id "\n"
expect -i $spawn_id "closed"
```


#### set up mongodb replica set

```
#!/bin/expect
spawn mongo --host opsmgr.example.com --port 27017
expect " > "
send "rs.initiate()\n";
expect "SECONDARY> "
after 3000
send "\n";
expect "PRIMARY> "
send "a=rs.conf()\n";
expect "PRIMARY> "
send "a.members\[0\].priority=20\n";
expect "PRIMARY> "
send "rs.reconfig(a)\n";
expect "PRIMARY> "
send "rs.add(\"opsmgr.example.com:27018\")\n";
expect "PRIMARY> "
send "rs.add(\"opsmgr.example.com:27019\")\n";
expect "PRIMARY> "
interact
```
