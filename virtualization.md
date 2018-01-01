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
