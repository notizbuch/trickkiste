# python

### download JSON data from web / http

```
#!/usr/bin/python

import urllib2
import json
import datetime

req = urllib2.Request("https://btc-e.com/api/2/ltc_btc/ticker")

f = urllib2.urlopen(req)

data = f.read()

try:
    decoded = json.loads(data)
    lastBTCUSD = decoded['ticker']['last']
    #print "last:", decoded['ticker']['last']

except (ValueError, KeyError, TypeError):
    print "JSON format error"

print datetime.datetime.utcnow().strftime("%Y,%m,%d,%H,%M,%S") + "," + `lastBTCUSD`
```

### put getchar function into separate file

```
file: myGetC.py
===============
import sys, tty, termios

def mygetcharfunction():
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return ch


file: test.py
=============

from myGetC import mygetcharfunction

print ('Please enter something: ')
x = mygetcharfunction()
print (x)
```
