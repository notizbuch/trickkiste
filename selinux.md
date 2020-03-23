### create custom module with whatever is needed:

```
set selinux temporarily to permissive:
vi /etc/selinux/config 
SELINUX=permissive
=> violations are allowed now but logged to /var/log/audit/audit.log

run software - whatever it is.

generate module:
cat /var/log/audit/audit.log | audit2allow -M myadditionalselinuxmodule01

now add the module:
semodule -i myadditionalselinuxmodule01.pp 

then re-enable SELINUX=enforcing
```

### apply SE permissions from one file to another file
```
chcon --reference=/old/file /new/file
(works for directories,too)
```
e.g. if "selinux permission denied" in /var/log/audit

### see SE linux info of files
```
ls -lZ
```
