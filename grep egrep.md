# grep / egrep
### prepend grep result with filename from variable

```
for i in `ls` ; do grep a $i | sed "s:\(.*\):$i \1:g" ; done 
```

