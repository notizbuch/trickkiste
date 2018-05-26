#### world readable / writeable share on Ubuntu 18.04
```
sudo apt install samba samba-common

mkdir /data
touch /data/test

cat > /etc/samba/smb.conf <<EOF
[global]
map to guest = bad user
usershare allow guests = yes

[data]
comment = File Share
path = /data
browsable =yes
writable = yes
guest ok = yes
read only = no
force user = nobody
EOF

systemctl enable smbd
systemctl start smbd
```


#### samba windows shares

```
        mount Windows share from Linux
        yum install samba samba-client cifs-utils
        mount.cifs //ip/sharename /mnt/eee -o user=name1,password=sharepassword
        /etc/fstab:
        //192.168.2.148/Downloads2 /mnt/eee cifs user=name1,password=sharepassword,iocharset=utf8,file_mode=0777,dir_mode=0777 0 0
        create a share on linux ; mountable from Windows
        yum install samba samba-client samba-common
        chmod 777 /mnt

        /etc/samba/smb.conf
         [public]
         comment = Public
         path = /mnt
         public = yes
         writable = yes
         printable = no
         guest ok = yes
         browseable = yes
         directory mask = 0777
         create mask = 0777

        /etc/selinux/config
         SELINUX=disabled
        chkconfig smd on
        iptables: port 445 needs to be accessible.
        service smb start

        add user:
        smbpasswd -a user01

        example: "ro" can be read by anybody, "rw" can also write but requires login:

        [ro]
        comment = Public
        path = /mnt
        public = yes
        writable = no
        printable = no
        guest ok = yes
        browseable = yes
        directory mask = 0777
        create mask = 0777

        [rw]
        comment = Public
        path = /mnt
        public = no
        writable = yes
        printable = no
        guest ok = no
        browseable = yes
        directory mask = 0777
        create mask = 0777
        valid users = user01
```
