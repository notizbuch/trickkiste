# bash

## IFS - using the internal field separator list


ignore spaces when processing lines (empty list of internal field separator IFS): 

```IFS= ; for i in `cat filename1`;do echo $i;done``` 

or

```cat my.list.txt | while read x ; do echo $x ; done```


same as (despite ' '): 

```cat filename1 | while IFS=' ' read i; do echo $i ; done``` 
 
treat each space as the beginning of a new field: 


```for i in `cat filename1`;do echo $i;done```

or (for illustration:) 

```IFS=$' ' ; for i in `cat filename1`;do echo $i | while read x ; do echo $x; done ;done```
 
treat each tab as the beginning of a new field but ignore spaces ( $'somestring' is a syntax for string literals with escape sequences) : 

```IFS=$'\t' ; for i in `cat filewithtabs`;do echo $i | while read x ; do echo $x; done ;done```

removing single quotes from filenames:

```
shopt -s nullglob
for i in *\'* ; do mv -v "$i" "${i/\'/}" ; done
```

## example bash script: number_checker.sh
```
#!/bin/bash

# number_checker.sh
# checks how many numbers in picks match the lotto draw

# picks:
# $ cat lotto649
# 01 02 09 32 37 45
# 02 03 06 07 11 21
# 02 07 19 23 36 48
# 03 06 18 33 39 44
# 04 05 13 16 26 47

# use filename and actual draw as parameters:
# $ ./number_checker.sh lotto649 13 18 19 20 35 40 14

cat $1 | while read line
do
        echo -n checking $line " "
    for number in $line
    do
        skip=1
        for draw in $@
        do
            if [ $skip -eq 1 ]; then skip=0; continue; fi
                let a="10#$draw"
                let b="10#$number"
                if [[ (( $a == $b )) ]] ; then
                    echo -n match: $a " "
                fi
        done

    done
        echo
done
```

#### bash prompt with user@hardcodedhostname:path :
```
vi /etc/bashrc
PS1='\u@myserver1:\w\$ '
```
