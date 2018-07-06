#### qemu on centos 7 

```
yum install qemu qemu-kvm qemu-img virt-manager libvirt libvirt-python libvirt-client virt-install virt-viewer bridge-utils

qemu-img create mydisk.img 30G
qemu-system-x86_64 -m 8192 -hda mydisk.img -boot d -cdrom /data/ISOs/ubuntu-17.04-server-amd64.iso
```

#### clone vmdk on esxi (linux commandline)
```
vmkfstools -i /vmfs/volumes/TERABYTE01/debian9-stretch-orig/debian9-stretch-orig.vmdk /vmfs/volumes/TERABYTE01/util/util2.vmdk
```

#### find IP address of virtualbox guest
```
VBoxManage guestproperty get MYVIRTUALMACHINENAME "/VirtualBox/GuestInfo/Net/0/V4/IP"
```

#### use hardware disk in VM
```
blkid
ls -l /dev/disk/by-id/
/usr/bin/VBoxManage internalcommands createrawvmdk -filename "/path1/disk1.vmdk" -rawdisk /dev/disk/by-id/diskid1
```
