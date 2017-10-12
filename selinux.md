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
