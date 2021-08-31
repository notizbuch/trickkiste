## iptables
```
    drop packets from a certain host

    iptables -t filter -I INPUT 1 -p icmp --source 192.168.2.2 -j DROP
    (-t filter not needed here because it is the default table
    "INPUT" is a built in chain of the filter table for packets destined to local sockets
    "DROP" is the target. A user defined chain be used as well.) 
```

#### drop packets to port 80
```
iptables -A INPUT -p tcp --destination-port 80 -j DROP
```

#### drop rules from chains ="open firewall"
```

    iptables -F
    iptables -t filter -F INPUT (more specific with table and chain) 

    add a rule / remove a rule from INPUT chain of default filter "filter"

    iptables -A INPUT -i eth0 -p tcp --dport 443 -j ACCEPT
    and remove it again:
    iptables -D INPUT -i eth0 -p tcp --dport 443 -j ACCEPT 

    add / remove rule at specific position

    iptables -t filter -I INPUT 1 --p icmp --source 11.22.33.44 -j DROP
    (to remove it, just turn -I into -D and leave out the '1' ) 

    port forwarding (prerouting)

    iptables -t nat -A PREROUTING -p tcp --dport 9090 -j REDIRECT --to-ports 8080
    show it: iptables -t nat -L 

    save and restore all rules

    iptables-save > file1
    iptables-restore < file1

    change default policy

    iptables -P INPUT DROP
    iptables -P OUTPUT DROP
    iptables -P FORWARD DROP 
```

#### local port forward:

```
iptables -t nat -I PREROUTING --src 0/0 --dst 192.168.1.1 -p tcp --dport 443 -j REDIRECT --to-ports 8443
```
can be in /etc/rc.local


#### use port on host to forward to another host:port
```
iptables -t nat -A OUTPUT -p tcp --dport 443 -j DNAT --to-destination DESTINATIONHOST:PORT
```


#### firewalld
```
firewall-cmd --list-all
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --remove-port=80/tcp --permanent
allow specific source:
firewall-cmd --permanent --zone=public --add-rich-rule='
  rule family="ipv4"
  source address="192.168.0.1/32"
  port protocol="tcp" port="80" accept'

firewall-cmd --complete-reload

Port forwarding:
firewall-cmd --zone=public --add-masquerade --permanent
firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toport=8080 --permanent

config file is at /etc/firewalld/zones/public.xml
```
