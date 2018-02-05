```
            ___________________________
            |                         |
            |       archive           |
            |_________________________|
                   ^          |        
                   |          |      
                  out         in       
            _______|_________\ /_______
            |                         |
            |       filesystem        |
            |_________________________|
                                       
```


#### copy files out to archive:
```cat myfilelist | cpio -ov > files.cpio```

(if relative paths are needed, use relative paths when creating archive)

#### copy files in from archive:
```cpio -idv < files.cpio```

( -d will create directories if they don't exist )

#### list
```cpio -t < files.cpio```

#### passthrough (for selective copying)
```find . -depth -print0 | cpio --null -pvd new-dir```

(depth first so write protected directories become read-only after files are already in them)
