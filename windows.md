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
