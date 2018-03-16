#### info about configuration
```
cat > /etc/httpd/conf.d/info.conf
<Location "/server-info">
    SetHandler server-info
</Location>
```
#### info about configuration 2
```
httpd -S
httpd -M
(shows loaded modules, e.g. to check which Multi-Processing Module (MPM) is in use )
```
