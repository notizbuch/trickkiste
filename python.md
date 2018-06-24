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

### encode and decode URLs:

```
import urllib
import json
urllib.urlencode({'data"':'hello','data2"':'hello2'})
'data2%22=hello2&data%22=hello'
urllib.unquote('data2%22=hello2&data%22=hello').decode('utf8')
u'data2"=hello2&data"=hello'
```

### read csv with built-in csv module
```
#!/usr/bin/python

import csv
with open('mydata.csv', 'rb') as csvfile:
  datareader = csv.reader(csvfile, delimiter='|', quotechar='\"')
  #datareader = csv.DictReader(csvfile)
  for row in datareader:
    print ', '.join(row)
    #print(row['fieldnamefromfirstline1'], row['fieldnamefromfirstline2'])
```

### record mp3 stream with date and time in filename
```
#!/usr/bin/python3

import datetime
import time
import os
import subprocess
now = datetime.datetime.now()
print(now)
outputfilename = "%s.mp3" % (now)
customtime = time.strftime("%Y%m%d_%H%M")
outputfilename2 = "stream-%s.mp3" % (customtime)

print("writing %s" % outputfilename2)
subprocess.call(["/usr/bin/ffmpeg", "-t", "3600", "-y", "-i", "https://example.com/stream.mp3", outputfilename2], stdout=open(os.devnull, "w"), stderr=subprocess.STDOUT)
```
