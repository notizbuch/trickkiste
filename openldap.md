### LDAP setup on centos 7:

slapd = openldap-servers : https://www.server-world.info/en/note?os=CentOS_7&p=openldap 

```
yum -y install openldap-servers openldap-clients
systemctl start slapd
systemctl enable slapd
firewall-cmd --add-service=ldap --permanent
firewall-cmd --reload
```

### setting admin pasword: olcRootPW

slappasswd 
generates:
```
{SSHA}<somestring>
```
chrootpw.ldif: 
```
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: {SSHA}<somestring>
```
ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif 

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif 

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif 


chdomain.ldif 
```
dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth"
  read by dn.base="cn=Manager,dc=example,dc=com" read by * none

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=example,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=Manager,dc=example,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcRootPW
olcRootPW: {SSHA}UOeMYlMGkIpW+86w3OVJzUb5f8aHd1UY

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange by
  dn="cn=Manager,dc=example,dc=com" write by anonymous auth by self write by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to * by dn="cn=Manager,dc=example,dc=com" write by * read
ldapmodify -Y EXTERNAL -H ldapi:/// -f chdomain.ldif
```


basedomain.ldif 
```
dn: dc=example,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
o: Example Company
dc: example

dn: cn=Manager,dc=example,dc=com
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=People,dc=example,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=example,dc=com
objectClass: organizationalUnit
ou: Group
```

ldapadd -x -D cn=Manager,dc=example,dc=com -W -f basedomain.ldif


Test:
ldapsearch -LLL -x -D 'cn=Manager,dc=example,dc=com' -b cn=Manager,dc=example,dc=com -w <thepasswordusedabove>

output:
```
dn: cn=Manager,dc=example,dc=com
objectClass: organizationalRole
cn: Manager
description: Directory Manager
```

ldapsearch -LLL -x -D 'cn=Manager,dc=example,dc=com' -b dc=example,dc=com -w <thepasswordusedabove>

```
dn: dc=example,dc=com
objectClass: top
objectClass: dcObject
objectClass: organization
o: Example Company
dc: example

dn: cn=Manager,dc=example,dc=com
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=People,dc=example,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=example,dc=com
objectClass: organizationalUnit
ou: Group
```


Adding user:


ldapadd -x -D "cn=Manager,dc=example,dc=com" -w aaaaaa <<EOF
```
dn: cn=testuser1,dc=example,dc=com
objectClass: inetOrgPerson
cn: testuser1
uid: testuser1
UserPassword: bbbbbb
sn: testlastname
EOF
adding new entry "cn=testuser1,dc=example,dc=com"
```

(instead of EOF block can also: -f file123.ldif )

### Phpldapadmin

```getsebool httpd_can_connect_ldap```

httpd_can_connect_ldap --> off

```setsebool -P httpd_can_connect_ldap on```

```getsebool httpd_can_connect_ldap```

httpd_can_connect_ldap --> on

config.php 

<?php

$config->custom->appearance['show_clear_password'] = true;
$config->custom->appearance['obfuscate_password_display'] = false;

$servers = new Datastore();
$servers->newServer('ldap_pla');
$servers->setValue('server','name','Local LDAP Server');
$servers->setValue('server','host','192.168.140.99');
$servers->setValue('server','base',array('dc=shibb-ldap-01,dc=example,dc=com'));
$servers->setValue('login','bind_id','cn=Manager,dc=shibb-ldap-01,dc=example,dc=com');
$servers->setValue('login','attr','dn');
$servers->setValue('login','bind_pass','thepasswordusedabove');

?>
