#### basic configuration that works for wifi

```
clients.conf file:

client 192.168.1.0/24 {
        ipv4addr        = 192.168.1.0/24
        secret          = someveryhardtoguesspassword
}

eap config file:
	default_eap_type = ttls

tls-config tls-common:
  private_key_password = 
  # (leave blank)
  private_key_file = /etc/freeradius/3.0/certs/mycert.key
  certificate_file = /etc/freeradius/3.0/certs/mycert.crt
  # dangerous: do not configure unless you issue certs
  #ca_file = NOTHINGUNLESSYOUKNOWWHATYOUDOING

ttls:
  default_eap_type = mschapv2
  use_tunneled_reply = yes

peap:
  default_eap_type = mschapv2
  use_tunneled_reply = yes
  
users file:

bob     Cleartext-Password := "passwordofbob"
	Tunnel-Type = VLAN,
	Tunnel-Medium-Type = IEEE-802,
	Tunnel-Private-Group-Id = "330",
	Reply-Message := "Hello, %{User-Name}"
  
test:
radtest bob passwordofbob 127.0.0.1 0 someveryhardtoguesspassword
(port is 1812)
```
