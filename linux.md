# linux

## SimpleHTTPServer / http.server
```
python3 -m http.server
python3 -m http.server 8080
python3 -m http.server 8000 --bind 127.0.0.1
python3 -m http.server --help
python -m SimpleHTTPServer
```

## mount so regular user has full access
```
mount -t cifs -o file_mode=0777,dir_mode=0777 //nas/share1 /mnt/nas/share1
```
## mount cifs with right version
```
mount -t cifs -o vers=[1234].0 //nas/share1 /mnt/nas/share1
```

## install tmux on CentOS 6.4

```
yum install ncurses-devel
tar xfz libevent-2.0.21-stable.tar.gz
tar xfz tmux-1.8.tar.gz
./configure && make ...
```

## edit /etc/X11/xorg.conf to use different resolution (CentOS 6.4 in VirtualBox)

```
Section "Screen"
   Identifier "Screen0"
   Device "Videocard0"
   Monitor "Monitor0"
   DefaultDepth 24
   SubSection "Display"
    Viewport 0 0
    Depth 24
    Modes "1356 843" "800x600" "640x480"
   EndSubSection
EndSection
```

## ldd libraries library path


```
ldd /usr/local/bin/tmux (shows which libs are required)
pvs /lib64/libc.so.6 (solaris: "print version section")
/sbin/ldconfig -p (list all avail. libraries)
/etc/ld.so.conf.d/ (configuration, store paths to libraries)
echo $LD_LIBRARY_PATH (can be used for adding paths temporarily )
example to solve library problem:
tmux
tmux: error while loading shared libraries: libevent-2.0.so.5: cannot open shared object file: No such file or directory
find / -name libevent-2.0.so.5
/usr/local/lib/libevent-2.0.so.5
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
-now tmux works 
```

## add existing user to existing group

```
usermod -a -G thisgroup1 thatuser1
```

## xargs

```
insert argument in the middle

echo a b c d e f g | xargs -IX echo before X after
before a b c d e f g after 

pass 2 or multiple arguments to command

echo a b c d e f g | xargs -n 2 echo
a b
c d
e f
g
```

## virtualbox

### mounting a shared folder that is shared by the host

```
mount.vboxsf share /share/

permament:
share /share vboxsf rw
in /etc/fstab

or

mount.vboxsf -w share /share
in /etc/rc.local
(more delay because share is sometimes not ready during boot leading to error) 
```

## mplayer - convert to wav file

```
mplayer -ss 500 -endpos 5 VOICE1130_002.MP3 -novideo -ao pcm:file=1.wav
(endpos= seconds from start of playback, ss=seconds from the beginning of the file) 

video output to text:
CACA_GEOMETRY=180x60 mplayer -vo caca ....
mplayer -vo matrixview ....
or in tmux:
DISPLAY= mpv --quiet -vo caca ....
```

## image manipulation

### remove metadata from jpg

```
sudo apt-get install libimage-exiftool-perl
exiftool -all= *.jpg 
```

## rsync

```
rsync --verbose --ignore-existing --recursive source destination
möglichst originalgetreu: --archive (-a includes -r automatically)
destination can be folder or ssh location or rsync daemon location (server::abcd)
rsync -av --copy-dirlinks
-u = only newer files
--remove-source-files = delete files from source after successful transfer
--delete = delete extraneous files in destination
--stats = output statistics afterwards
-c, --checksum = update based on checksum (not timestamp)
--filter=RULE e.g. 3 ways to do the same thing:
rsync -a --filter="-! */" '-'=exclude '!'=not '*/'=matches directories
rsync -a -f"+ */" -f"- *" source destination =all directories, nothing else
rsync -r --include='*/' --exclude='*' =only directories
```

### VNC server
```
sudo apt-get install x11vnc
```
Create a password for your user:
```
x11vnc -storepasswd
```
Start protected by password:
```
x11vnc -usepw
```
Allow through firewall
```
iptables -A INPUT -p tcp --dport 5900 -j ACCEPT
firewall-cmd --zone=public --add-port=5900/tcp --permanent
firewall-cmd --complete-reload
```
Windows: Use TightVNC ( http://www.tightvnc.com/ )

 
## hardware

### control output to additional monitor from console with xrandr

```
xrandr
shows all video devices

xrandr --output VGA1 --mode 1600x900
xrandr --output LVDS1 --off

reverse:

xrandr --output VGA1 --off
xrandr --output LVDS1 --mode 1280x800
```

### delete duplicate files in folder structure even if they have different names

```
fdupes -rdN <folder>
```

### set up webserver to serve files from current directory with one line
```
python -m SimpleHTTPServer
python -m SimpleHTTPServer <LISTENINGPORT>
```

#### mount VM disk partition with correct offset:
```
fdisk -lu sda.img

root@nas:/main/ulrich/vms# fdisk -lu raw.img
Disk raw.img: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xd4b232c0

Device     Boot Start      End  Sectors Size Id Type
raw.img1   *     2048 16775167 16773120   8G 83 Linux

offset = start * sector size 
2048 * 512 = 1048576

losetup -o 1048576 /dev/loop0 sda.img

mount /dev/loop2 mountpointforloop/

===
detach:
umount mountpointforloop/
losetup -d /dev/loop2
```

#### cryptsetup create and use drive

```
SETUP:
dd if=/dev/zero of=mydisk bs=64k count=15625
losetup /dev/loop2 mydisk
cryptsetup luksFormat /dev/loop2
cryptsetup luksOpen /dev/loop2 mydecrypt
mkfs.ext4 /dev/mapper/mydecrypt
cryptsetup luksClose mydecrypt

USE:
losetup /dev/loop2 mydisk
cryptsetup luksOpen /dev/loop2 mydecrypt
mkdir mydecryptmount
mount /dev/mapper/mydecrypt mydecryptmount

(shortcut skipping losetup:
cryptsetup luksOpen mydisk mydecrypt
)

CLOSE:
umount mydecryptmount
cryptsetup luksClose mydecrypt
```

#### mount exfat
```
apt-get install exfat-fuse exfat-utils
```

#### mount logical volumes
```
vgscan
vgchange -ay someVolGrpName
(or activate all known volumes: vgchange -a y )
lvs
mount /dev/someVolGrpName/X /mnt/directory

more info:
pvscan
vgdisplay -v
pvdisplay -v
lvdisplay -v
```



#### examine disk via Self-Monitoring, Analysis, and Reporting Technology ( S.M.A.R.T )
```
package: smartmontools

see available tests:
smartctl -c /dev/sdc

run test:
smartctl -t short /dev/sda
or:
smartctl -t long /dev/sda

results:
smartctl -a /dev/sda 
or selectively:
smartctl -l selftest /dev/sda
```

#### add IP address to interface
```
ip addr add 192.168.1.10/24 dev enp8s0
```
#### add route using ip command
```
ip route add 192.168.1.0/24 dev tun0
```

#### rescue (ddrescue) - skip bad blocks, retry only a number of times:
```
ddrescue -r2 /data/mycorruptsourcefile /mnt/a/mycopyofcorruptsourcefile
ddrescue -d -r2 /dev/sda /mnt/a/mycorruptdriveimage
```

#### Packages needed on centos7 to start X11 window:
```
yum install xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils xeyes
```
now xeyes works via SSH X forwarding.

#### simple port forwarding
```
socat tcp-listen:PORT,reuseaddr,fork tcp:DESTINATIONIP:PORT
```
