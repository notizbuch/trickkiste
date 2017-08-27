## solaris

```
    handling solaris zones

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
