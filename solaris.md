### handling solaris zones

```
    clone solaris zone:
     zonecfg -z oldzone01 export > newzone02.cfg
    then edit newzone02.cfg for IP etc.
     zonecfg -z newzone02 -f newzone02.cfg
     zoneadm -z oldzone01 halt
     zoneadm -z newzone02 clone oldzone01
     zoneadm -z oldzone01 boot
    list zones:
     zoneadm list -v
    reboot:
     zoneadm -z my-zone reboot
    uninstall:
     zoneadm -z my-zone uninstall -F
    login:
     zlogin -l user zonename
```

### listing disks on system, list partitions, backup drive
```
df -k
format
[then select a disk]
partition
print
[Ctrl-D]
then backup using dd: backup the partition that covers all cylinders:
dd if=/dev/rdsk/c1t1d0s2 of=c1t1d0s2.img
```

### check CPU and memory
```
psrinfo -pv
prtconf     <- lists all hardware
```
