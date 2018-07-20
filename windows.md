#### open policy editor

```
domain => Group Policy editor (gpedit.msc)
standalone computer => secpol.msc
```

#### prevent user login , but still allow file share access
```
->Security Settings
->Local Policies
->User Rights Assignment
->"Deny log on locally"
```

#### file sharing and server message block (SMB) ports
```
UDP 135-139,445
TCP 135-139,445
```

#### local users and groups
```
lusrmgr.msc
```

#### bring up SQL server manager to make it listen on TCP socket
```
C:\Windows\SysWOW64\SQLServerManager14.msc
disable other access methods, server will listen on 0.0.0.0:1433
```


#### cygwin : rsync making all files with accessible permissions
```
rsync.exe -rv --chmod=ugo=rwx ...
```
#### on screen keyboard
```
OSK.EXE
```
