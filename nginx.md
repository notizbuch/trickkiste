#### output to stdout for debugging
```
daemon off;
error_log /dev/stdout info;
```

#### reverse proxy based on domain name
```
error_log  off;
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    server {
    listen       80 default_server;
    listen       [::]:80 default_server;
        server_name b.example.com;
    location / {
        proxy_pass http://192.168.1.10;
    }
    }
    server {
    listen       80;
    listen       [::]:80;
        server_name a.example.com;
    location / {
        proxy_pass http://192.168.1.11;
    }
    }

    access_log  off;
    error_log off;
    sendfile        on;
    keepalive_timeout  65;
}

```
