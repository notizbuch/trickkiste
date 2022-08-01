## netcat - nc - see also socat (socket cat)

```
    nc - basic examples

    transfer disk image from server A to server B:

    serverB: nc -l -p 5790 | dd of=/dev/sda

    Afterwards, on serverA, run: dd if=/dev/sda | nc 192.168.1.65 5790

    one line web server:

    while true; do nc -l 80 < myhtml.txt ; done

    pulling web site:

    nc example.com 80
    GET / HTTP/1.1
    Host: example.com

```

## netcat act as proxy, listening on 80 and forwarding to server1, writing HTTP requests to /tmp/log1
```
ncat -lkv 0.0.0.0 80 -c 'tee /tmp/log1 | ncat -v server1.example.com 8080 | tee /tmp/log2'
```
