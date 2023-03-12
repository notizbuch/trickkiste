#!/bin/bash

if test "$(ps -ef|grep -v grep|grep $0|wc -l)" -gt 2;then exit; fi

sleep 60
while :;do

if (ping -q -w 1 -c 1 192.168.1.254); then echo OK ; else

echo NOTOK
modprobe -r igb
sleep 1
modprobe igb
sleep 1

# add tap interfaces back to bridges
#pfs to T
#ip link set tap102i0 master vmbr1
#pfs to E
#ip link set tap102i3 master vmbr12

# add the intel NICs back to bridges:
brctl addif vmbr1 enp5s0f2
brctl addif vmbr1 enp5s0f3
brctl addif vmbr12 enp5s0f0

fi
sleep 15
done
