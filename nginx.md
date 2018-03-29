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
            allow   192.30.252.0/22;
            deny    all;
            proxy_pass http://192.168.1.10;
            proxy_set_header Host            b.example.com;
            proxy_set_header X-Forwarded-For $remote_addr;
        }
    }
    server {
    listen       80;
    listen       [::]:80;
        server_name a.example.com;
        location / {
            resolver 8.8.8.8 8.8.4.4;
            set $proxy_pass_url http://myurl.example.com:20123;
            proxy_pass $proxy_pass_url;
        }
    }

    access_log  off;
    error_log off;
    sendfile        on;
    keepalive_timeout  65;
}

( proxy_set_header can change or prevent Host header from changing if needed )

```

#### IP restriction
```
        location / {
                allow   192.168.1.0/24;
                allow   192.168.2.0/24;
                deny    all;
                ...
        }
```
