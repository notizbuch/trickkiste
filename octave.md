# octave

## create a chart from matrix / CSV

```
#!/usr/bin/octave

# CSV Format:
# 2013,12,30,00,31,14,719.00199999999995 (%Y,%m,%d,%H,%M,%S,Kurs)
# python: print datetime.datetime.utcnow().strftime("%Y,%m,%d,%H,%M,%S") + "," + `lastBTCUSD`

dataBTC = dlmread ("btc_usd" );
U = [0,0;0,0;86400,0;3600,0;60,0;1,0;0,1]
B = dataBTC * U
#blau:
plot(B(:,1),B(:,2), "3");
hold on

dataLTC = dlmread ("ltc_usd");
U = [0,0;0,0;86400,0;3600,0;60,0;1,0;0,31.072]
C = dataLTC * U
#rot:
plot(C(:,1),C(:,2), "1");

print ausgabe.png
```
