### set up Zabbix server and agent on Centos 7 servers

```
Server
==========

rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm

yum install zabbix-server-mysql zabbix-web-mysql
yum install zabbix-agent
yum -y install mariadb-server 
systemctl start mariadb-server
systemctl start mariadb
systemctl enable mariadb
mysql -u root


create database zabbix character set utf8;
grant all privileges on zabbix.* to zabbix@localhost identified by 'MyPassword123HJKL';
flush privileges;

cd /usr/share/doc/zabbix-server-mysql-3.4.2/
zcat create.sql.gz | mysql -uzabbix -p zabbix
MyPassword123HJKL

vi /etc/zabbix/zabbix_server.conf
DBPassword=MyPassword123HJKL

vi /etc/httpd/conf.d/zabbix.conf
php_value date.timezone America/Vancouver

systemctl restart httpd
systemctl start zabbix-server
systemctl enable zabbix-server

http://1.1.1.1/zabbix should work.


/usr/lib/systemd/system/zabbix-server.service

/usr/sbin/zabbix_server -c /etc/zabbix/zabbix_server.conf

cd /etc/httpd/conf.d
rm autoindex.conf README userdir.conf welcome.conf

vi /etc/httpd/conf/httpd.conf
DocumentRoot "/usr/share/zabbix"

go through install at:
http://1.1.1.1
until:
Congratulations! You have successfully installed Zabbix frontend.
Configuration file "/etc/zabbix/web/zabbix.conf.php" created.

http://192.168.232.188
login: admin/zabbix

firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=10051/tcp --permanent
firewall-cmd --zone=public --add-port=10051/udp --permanent
firewall-cmd --complete-reload


pitfall:
/var/log/zabbix/zabbix_server.log
cannot set resource limit: [13] Permission denied
cannot disable core dump, exiting..

=> setenforce 0  prevents it 

permament, with selinux:

Agent on server that is monitored:
===================================

rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-1.el7.centos.noarch.rpm

yum install zabbix-agent


generate PSK for secure connection:

sh -c "openssl rand -hex 32 > /etc/zabbix/zabbix_agentd.psk"

cat /etc/zabbix/zabbix_agentd.psk
=> copy key

vi /etc/zabbix/zabbix_agentd.conf

Server=1.1.1.1

TLSConnect=psk

TLSAccept=psk

TLSPSKIdentity=MyIdentity01
( = PSK ID in Zabbix web interface )

TLSPSKFile=/etc/zabbix/zabbix_agentd.psk

systemctl start zabbix-agent
systemctl enable zabbix-agent

firewall-cmd --zone=public --add-port=10050/tcp --permanent
firewall-cmd --zone=public --add-port=10050/udp --permanent
firewall-cmd --complete-reload
```
notes:
```
/var/log/zabbix/zabbix_agentd.log - Hostname=X has to match
letter by letter to the host name specified in the host setup 
on the server.

ZBX turns green in UI after an item is monitored via Zabbix agent.

test with zabbix-get:
zabbix_get -s HOSTIPADDRESS --tls-connect psk --tls-psk-identity MyIdentity01 --tls-psk-file /etc/zabbix/zabbix_agentd.psk -k 'vm.memory.size[available]'
see https://www.zabbix.com/documentation/3.4/manual/appendix/items/supported_by_platform, e.g.: vm.memory.size[available], system.localtime, system.hostname, proc.num[,,run], system.cpu.load[percpu,avg1], system.uptime, agent.version

send data to zabbix server custom item:
zabbix_sender -z ZABBIXSERVERIPADDRESS -s HOSTNAMEINZABBIX --tls-connect psk --tls-psk-identity MyIdentity01 --tls-psk-file /etc/zabbix/zabbix_agentd.psk -k my-custom-item01 -o 10

when setting up an action to send an email, the user needs to have read access permission in order to be a recipient for an action.
```

