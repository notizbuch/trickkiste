### LDAP setup on centos 7:

slapd = openldap-servers : https://www.server-world.info/en/note?os=CentOS_7&p=openldap 

```
yum -y install openldap-servers openldap-clients
systemctl start slapd
systemctl enable slapd
firewall-cmd --zone=public --add-port=636/tcp --permanent
firewall-cmd --zone=public --add-port=389/tcp --permanent
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

```
yum install httpd phpldapadmin 
iptables -L
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --complete-reload
cd /etc/phpldapadmin/
vi config.php 
cd /etc/httpd/conf.d/
rm -f welcome.conf userdir.conf README autoindex.conf
systemctl restart httpd
vi phpldapadmin.conf
   Require all granted
systemctl restart httpd
   http://<IP>/phpldapadmin/
getsebool httpd_can_connect_ldap
setsebool -P httpd_can_connect_ldap on
```

config.php 
```
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
```
another config.php for phpladpadmin (works with "generate initial configuration" below):
```
<?php

$config->custom->appearance['show_clear_password'] = true;
$config->custom->appearance['obfuscate_password_display'] = false;

$servers = new Datastore();
$servers->newServer('ldap_pla');
$servers->setValue('server','name','Local LDAP Server');
$servers->setValue('server','host','192.168.1.113');
$servers->setValue('server','base',array('cn=config'));
$servers->setValue('login','bind_id','cn=startpunkt,cn=config');
$servers->setValue('login','attr','dn');
$servers->setValue('login','bind_pass','aaaaaa');

?>
```

### alternative: compile OpenLDAP on Centos 7

```
http://download.oracle.com/berkeley-db/
Berkeley DB first:
db-6.0.19.tar.gz
./dist/configure
make
make install
/usr/local/BerkeleyDB.6.0/bin

now openldap-2.4.45.tgz :
yum -y install libtool-ltdl libtool-ltdl-devel libtool cyrus-sasl cyrus-sasl-devel
export CPPFLAGS="-I/usr/local/BerkeleyDB.6.0/include -I/usr/include/sasl"
export LDFLAGS="-L/usr/local/BerkeleyDB.6.0/lib -L/usr/lib64 -L/usr/lib64/sasl2"
export LD_LIBRARY_PATH="/usr/local/BerkeleyDB.6.0/lib:/usr/lib64:/usr/lib64/sasl2"  (or add to /etc/ld.so.conf ; ldconfig)
# change version in path^ 0x060014
./configure
make depend 
make
make test
make install
```
#### generate initial configuration in cn=config format based on slapd.conf file (use /usr/local/etc/openldap/ldap.conf)
```
man /usr/local/share/man/man5/ldap.conf.5

cp /usr/local/etc/openldap/ldap.conf /tmp

cat >> /tmp/ldap.conf
database config
rootdn "cn=startpunkt,cn=config"
rootpw aaaaaa

mkdir /tmp/myldapconf
/usr/local/sbin/slaptest -f /tmp/ldap.conf -F /tmp/myldapconf

(converted rootDN and rootPW are here now:
/tmp/myldapconf/cn=config/olcDatabase={0}config.ldif:olcRootPW:: YWFhYWFh
/tmp/myldapconf/cn=config/olcDatabase={0}config.ldif:olcRootDN: cn=startpunkt,cn=config
)
```
#### run it (foreground, debug output to terminal):
```
/usr/local/libexec/slapd -d3 -F /tmp/myldapconf
'-d3' means foreground, debug mode
```
#### configure more:

```
ldapadd -Y EXTERNAL -H ldapi:/// -f /usr/local/etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /usr/local/etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /usr/local/etc/openldap/schema/inetorgperson.ldif

```

#### notes:
```
URL	Protocol	Transport
ldap:///	LDAP	TCP port 389
ldaps:///	LDAP over SSL	TCP port 636
ldapi:///	LDAP	IPC (Unix-domain socket)

default ldapi:/// above uses IPC socket /usr/local/var/run/ldapi by default.
to make slapd listen on that socket:
/usr/local/libexec/slapd -h ldapi://%2Fusr%2Flocal%2Fvar%2Frun%2Fldapi -d 256 -F /tmp/myldapconf
```
