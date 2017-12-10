#### simple /etc/vsftpd/vsftpd.conf configuration for public ftp server with anonymous login

```
anonymous_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
pasv_enable=yes
anon_root=/data/ftp-data
pasv_min_port=40000
pasv_max_port=65500
pasv_address=SOMEEXTERNALIPHERE
```
