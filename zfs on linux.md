## ZFS on Linux

### create partitions that leave room (in case of replacement drives with fewer sectors) using parted on 4TB drive

#### getting information about drives
```
smartctl -a /dev/sdc
fdisk /dev/sdc

one sector = 512 Bytes

parted /dev/sdc
mklabel gpt
unit TB
unit s

mkpart primary 4096s 7814030000s

partition should show up now under

find /dev/ -maxdepth 3  |grep disk
```

### create "striped mirror" using 4 partitions on different drives (= raid10):
```
zpool create -f DATA1 mirror /dev/disk/by-partuuid/768278e7-4ee1-2311-a657-d86c0bdf5c9b /dev/disk/by-partuuid/c236963c-a63d-42de-968f-15ca8bb2384e mirror /dev/disk/by-partuuid/804b238e-38fe-4fe5-a023-1cc5a977e8bd /dev/disk/by-partuuid/b1c9232b-d339-4723-9e65-16bfd20023d1
```
(The second mirror keyword = new top-level virtual device. Data is striped across mirrors, with data redundant between disk pairs)

### drive replacement:

```
ls /dev/disk/by-id/
zpool offline rz2pool <mydeviceid>
zpool replace -f poolname diskid

other way:
zpool detach mytank ata-INTEL_SSDSC2BW120H6_CVTR528400RT120AGN
zpool status

zpool attach -f mytank ata-INTEL_SSDSC2BW120H6_CVTR5283073N120AGN ata-INTEL_SSDSC2BW120H6_CVTR528400RT120AGN       (first param=previous disk ; second= new disk)


```

### Turn off unnecessary options
```
zfs set atime=off poolname
zfs set dedup=off poolname
```

### experimenting with dummy drives
```
dd if=/dev/zero of=disk1 bs=1024k count=500
dd if=/dev/zero of=disk2 bs=1024k count=500
/sbin/modprobe zfs
losetup /dev/loop1 disk1
losetup /dev/loop2 disk2
zpool create mytank1 /dev/loop1 /dev/loop2
df -h
```
#### create ZFS filesystem on the volume:
```
zfs create mytank1/ds1
zfs create mytank1/ds2
zfs destroy mytank1/ds2
```

#### Mount datasets
```
zfs mount mytank1/ds1
```


#### get / set dataset info, e.g. mountpoint

```
sudo zfs get all
sudo zfs set mountpoint=/my_mount01 data
```

#### enable zfs service (to auto-import and -mount) 
```
systemctl enable zfs.target
```

#### check performance:
```
zpool iostat -v
```

#### mount ZFS after re-installing OS
`pacman -S zfs`  
`zpool import` # shows what is available for import  
`zpool import -f mypool`  
