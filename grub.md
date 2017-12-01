#### grub problem on ASUS laptop solved - Windows messed up UEFI boot

```
Used rEFInd rescue media
https://wiki.debian.org/GrubEFIReinstall
To boot anyway into debian

Then just:

mount /dev/sda4 /mnt/efi
apt-get install --reinstall grub-efi
grub-install /dev/sda
Update-grub

worked
```
