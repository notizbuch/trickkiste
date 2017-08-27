# sed

## only text between second and third blank line

``` sed -e '1,/^$/ d' -e '1,/^$/ d' -e '/^$/,$ d' ```

## print matching line and one line after

``` sed -n '/myregex/ {p;n;p;}' filename ```

## insert newline before 2nd line

``` sed '2 i\newline' filename ```

## print line number based on bash variable

``` variable1=5 ; cat testdata | sed $variable1'q;d' ```

## print range with line numbers ( -n disables implicit line printing)

``` sed -n '4628,6789p' filename ```

## negation: print all lines except 1-5

``` sed '1,5!d' ```

## get IPs ip addresses

``` sed -rn '/([0-9]{1,3}\.){3}[0-9]{1,3}/p' ```

## hexadecimal

``` sed '/bvfn/ s|bv|\x41|' ```
