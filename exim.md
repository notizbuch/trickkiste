### exim configuration file to save messages to disk except if they are to example.com

```
no_queue_only
add_environment = <; PATH=/bin:/usr/bin
keep_environment =

domainlist local_domains = @ : localhost : localhost.localdomain
domainlist relay_to_domains = *
hostlist   relay_from_hosts = *

acl_smtp_mail = acl_check_mail
acl_smtp_rcpt = acl_check_rcpt
acl_smtp_data = acl_check_data
acl_smtp_mime = acl_check_mime

tls_advertise_hosts = *

tls_certificate = /etc/pki/tls/certs/exim.pem
tls_privatekey = /etc/pki/tls/private/exim.pem

local_interfaces = 0.0.0.0

daemon_smtp_ports = 25

never_users = root

host_lookup =

auth_advertise_hosts =

rfc1413_hosts = *
rfc1413_query_timeout = 5s

ignore_bounce_errors_after = 2d

timeout_frozen_after = 7d


begin acl

acl_check_mail:

  accept

acl_check_rcpt:

  accept


acl_check_data:

  warn logwrite = Subject=$h_Subject:
  accept

acl_check_mime:

  accept

begin routers


bug_notify_as:
  driver = accept
  condition = ${if eqi {$domain}{example.com}}
  transport = remote_smtp

bug_accept:
  driver = accept
  #condition = ${if eqi {$local_part}{user123}}
  condition = ${if ! eqi{$sender_address}{user456@other.domain.com}}
  condition = ${if eqi {$domain}{other.domain.com}}
  transport = mypipe
  unseen

lokalkopie:
  driver = accept
  transport = local_delivery

begin transports

remote_smtp:
  driver = smtp
  hosts = smarthost.example.com
  hosts_override

local_delivery:
  driver = appendfile
  create_directory = true
  file = /emails/${domain}/${local_part}@${domain}_{$sender_address}_{$message_exim_id}_${sg{${sg{$tod_full}{ }{_}}}{:}{_}}.eml
  delivery_date_add
  envelope_to_add
  return_path_add
  group = mail
  mode = 0660

mypipe:
  driver = pipe
  user = apache
  group = apache
  command = /var/www/html/bugzilla/email_in.pl
  #command = "/etc/exim/ubpipe.sh"
  #command = "tee /tmp/ub1"
  #transport_filter = /usr/bin/sudo -u apache /var/www/html/bugzilla/email_in.pl

begin retry
*                      *           F,2h,15m; G,16h,1h,1.5; F,4d,6h

begin rewrite

begin authenticators


```
