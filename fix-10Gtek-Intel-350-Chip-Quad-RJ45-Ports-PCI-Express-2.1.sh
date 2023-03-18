#!/bin/bash

if test "$(/usr/bin/ps -ef|grep -v grep|grep $0|wc -l)" -gt 3;then exit; fi
#if pidof -x "$0" ;then echo $0 already running; exit; fi

sleep 60
while :;do

if (ping -q -w 1 -c 1 192.168.1.254); then echo OK ; else 

echo NOTOK

# reset PCIE device
echo "1" > /sys/bus/pci/devices/0000:05:00.0/remove
echo "1" > /sys/bus/pci/devices/0000:05:00.1/remove
echo "1" > /sys/bus/pci/devices/0000:05:00.2/remove
echo "1" > /sys/bus/pci/devices/0000:05:00.3/remove
sleep 2
echo "1" > /sys/bus/pci/rescan

ifdown enp5s0f0
ifdown enp5s0f1
ifdown enp5s0f2
ifdown enp5s0f3

/usr/sbin/modprobe -r igb
sleep 1
/usr/sbin/modprobe igb
sleep 1

ifdown enp5s0f0
ifdown enp5s0f1
ifdown enp5s0f2
ifdown enp5s0f3
ifup enp5s0f0
ifup enp5s0f1
ifup enp5s0f2
ifup enp5s0f3

/usr/sbin/ethtool -s enp5s0f2 autoneg off speed 1000 duplex full
/usr/sbin/ethtool -s enp5s0f3 autoneg off speed 1000 duplex full
/usr/sbin/ethtool -A enp5s0f2 rx off tx off
/usr/sbin/ethtool -A enp5s0f3 rx off tx off

# add tap interfaces back to bridges
#pfs to T
ip link set tap102i0 master vmbr1
#pfs to E
ip link set tap102i3 master vmbr12

# add the intel NICs back to bridges:
/usr/sbin/brctl addif vmbr1 enp5s0f2
/usr/sbin/brctl addif vmbr1 enp5s0f3
/usr/sbin/brctl addif vmbr12 enp5s0f0

fi
sleep 15
done


