#### install expect on debian

```
tar xf expect5.45.3.tar.gz
apt-get -y install tcl tcl-dev
.configure
make
make install
echo /usr/lib/expect5.45.3 >> /etc/ld.so.conf
ldconfig
```
