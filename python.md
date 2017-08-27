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
