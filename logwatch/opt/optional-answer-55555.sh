#!/bin/bash
while : ; do
/usr/bin/perl -e 'while (1) { print "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" }' | nc -l 55555 > /dev/null 2>&1
date
done
