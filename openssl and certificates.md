## ssl and certificates

#### generating a private key - public key pair / certificate e.g. for Apache
```
    generate key pair in .pem (text) format:
     openssl genrsa -des3 -out keys.pem 2048
    optionally remove password (note in key file it says "encrypted" or not):
     openssl rsa -in keys.pem -out keys.pem.key_no_password
    extract public key:
     openssl rsa -in keys.pem -pubout > pubkey.key
    generate CSR (needs both priv/pub key):
     openssl req -new -key keys.pem -out pubkey.key.csr
    optionally examine the CSR - it contains the public key:
     openssl req -in pubkey.key.csr -text -pubkey -subject -verify
    sign the CSR with a key (here it's the same private key = self-signed):
     openssl x509 -req -days 36500 -in pubkey.key.csr -signkey keys.pem -out pubkey.key.crt 
```

#### example use in NGINX
```
server {
  listen              443      default_server ssl;    
  listen              [::]:443 default_server ssl;    
  server_name         _;
  ssl_certificate     /etc/myssl/pubkey.key.crt;
  ssl_certificate_key /etc/myssl/keys.pem.key_no_password;
  ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;                                     
  ssl_ciphers         HIGH:!aNULL:!MD5;                                          
  location / {                         
     root /data/www/default;
  }                                    
}
```

#### generating a certificate chain for testing
```
    openssl genrsa -des3 -out myroot.pem 2048
    openssl rsa -in myroot.pem -out myroot.pem_nopw
    mv myroot.pem_nopw myroot.pem
    openssl req -new -key myroot.pem -out myroot.pem.csr -subj "/C=US/ST=/L=/O=MyOrg1/CN=myroot"
    openssl x509 -req -days 1800 -in myroot.pem.csr -signkey myroot.pem -out myroot.pem.crt

    openssl genrsa -des3 -out myintermediate1.pem 2048
    openssl rsa -in myintermediate1.pem -out myintermediate1.pem_nopw
    mv myintermediate1.pem_nopw myintermediate1.pem
    openssl req -new -key myintermediate1.pem -out myintermediate1.pem.csr -subj "/C=US/ST=/L=/O=MyOrg2/CN=myintermediate1"
    openssl x509 -req -days 1800 -in myintermediate1.pem.csr -CA myroot.pem.crt -CAkey myroot.pem -set_serial 20 -out myintermediate1.pem.crt

    openssl genrsa -des3 -out myintermediate2.pem 2048
    openssl rsa -in myintermediate2.pem -out myintermediate2.pem_nopw
    mv myintermediate2.pem_nopw myintermediate2.pem
    openssl req -new -key myintermediate2.pem -out myintermediate2.pem.csr -subj "/C=US/ST=/L=/O=MyOrg3/CN=myintermediate2"
    openssl x509 -req -days 1800 -in myintermediate2.pem.csr -CA myintermediate1.pem.crt -CAkey myintermediate1.pem -set_serial 200 -out myintermediate2.pem.crt

    openssl genrsa -des3 -out mydomain1.pem 2048
    openssl rsa -in mydomain1.pem -out mydomain1.pem_nopw
    mv mydomain1.pem_nopw mydomain1.pem
    openssl req -new -key mydomain1.pem -out mydomain1.pem.csr -subj "/C=US/ST=/L=/O=MyOrg3/CN=mydomain1"
    openssl x509 -req -days 1800 -in mydomain1.pem.csr -CA myintermediate2.pem.crt -CAkey myintermediate2.pem -set_serial 2000 -out mydomain1.pem.crt

    display certificate:
    openssl x509 -in mydomain1.pem.crt -text 
```

#### check expiry via HTTPS connection
```
openssl s_client -connect myserver:443 | openssl x509 -text -dates
```

#### check if signer matches between cert and key
```
openssl rsa -noout -modulus -in /cert.key
openssl x509 -noout -modulus -in /cert.crt
```

#### compare public key of certificate with public key of private key
```
openssl pkey -in file.key -pubout -outform pem        | sha256sum
openssl x509 -in cert.pem -pubkey -noout -outform pem | sha256sum
```

#### split ca chain into separate files
```
awk 'BEGIN {ca=0;} /BEGIN CERT/{ca++} { print > "cert." ca ".pem"}' < ca.pem
```

#### check one cert is issuer of another cert (without complete chain):
```
openssl verify -no-CAfile -no-CApath -partial_chain -trusted intermediateCA.crt pem.pem
```
