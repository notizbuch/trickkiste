
### check if Centos server is vulnerable to CVE:
```
yum install yum-plugin-security
yum updateinfo info --cve CVE-2017-9798
```
#### or other way:
```
rpm -q --changelog httpd | grep CVE-2017-9798
```
