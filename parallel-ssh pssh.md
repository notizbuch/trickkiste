##    parallel-ssh pssh example
```
myname@myname-VirtualBox ~/psshtest $ parallel-ssh -h serversliste -l fox -A -i '(date;uptime;date)'
Warning: do not enter your password if anyone else has superuser
privileges or access to your account.
Password:
[1] 18:19:48 [SUCCESS] server1
Fri Aug 4 18:19:47 PDT 2023
18:19:47 up 27 min, 0 users, load average: 0.00, 0.01, 0.02
Fri Aug 4 18:19:47 PDT 2023
[2] 18:19:48 [SUCCESS] server2
Fri Aug 4 18:19:48 PDT 2023
18:19:48 up 1:08, 0 users, load average: 0.00, 0.01, 0.05
Fri Aug 4 18:19:48 PDT 2023
[3] 18:19:48 [SUCCESS] server3
Fri Aug 4 18:19:48 PDT 2023
18:19:48 up 1:08, 0 users, load average: 0.00, 0.01, 0.02
Fri Aug 4 18:19:48 PDT 2023
[4] 18:19:48 [SUCCESS] server4
Fri Aug 4 18:19:48 PDT 2023
18:19:48 up 27 min, 0 users, load average: 0.00, 0.01, 0.05
Fri Aug 4 18:19:48 PDT 2023

-h -> file with hostnames as arg ; alternative: -H 'host1 host2 ...'
-A -> ask for password (for hosts with no public key access)
-i -> print output of commands
```
