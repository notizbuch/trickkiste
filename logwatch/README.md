### using logwatch to get email notifications about connection attempts - a primitive IDS

```
notes:
Configuration tested on CentOS Linux release 7.4.1708 (Core) with logwatch-7.4.0-32.20130522svn140.el7.noarch 

steps:
1) set up iptables:
systemctl stop firewalld && systemctl disable firewalld && yum remove firewalld
yum install iptables-services && systemctl enable iptables && systemctl start iptables
to log all incoming connections to unused syslog facility "error" need this rule:
-A INPUT -p tcp --tcp-flags SYN,ACK SYN -j LOG --log-level error --log-prefix "New Connection: "
(see /etc/sysconfig/iptables )

2) prepare rsyslog:
/etc/rsyslog.conf:
error.*                                                 /var/log/iptables
systemctl restart rsyslog

3) prepare Postfix:
/etc/postfix/main.cf
relayhost = <someIP>
systemctl restart postfix

4) install logwatch:
yum -y install logwatch
Documentation: /usr/share/doc/logwatch-7.4.0/HOWTO-Customize-LogWatch
rm /etc/cron.daily/0logwatch

5) configure logwatch to email reports only on new log entries in /var/log/iptables
use the included files in the etc and opt
```
