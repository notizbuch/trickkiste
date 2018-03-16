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
```
