# perl

## perl-oneliners

using perl as grep
```
perl -ne 'print if /a/' 
```
base64 decoder / encoder
```
perl -MMIME::Base64 -le 'print decode_base64("mybase64string")'
perl -MMIME::Base64 -ne 'print decode_base64($_)' filename
perl -MMIME::Base64 -e 'print encode_base64("\000"."username"."\000"."pass"."\000");' to generate AUTH PLAIN string (for SMTP)
```
lazy regex matching
```
perl -pe 's/\>.*?somestring/>\tsomestring/ig' (remove as few characters as possible before somestring) 
```
using perl as sed to replace, use bash variable, replace in-place (-i)
```
perl -p -i -e 's/<tag1><tag2 attr1=.*?'$BASHVARIABLE1'.*?tag2>\n//g' filename1 
```
print multiple regex matches
```
perl -nle 'print $1 if /name=(\w+)/; print $1 if /age=(\d+)/' filename
```
alternatives:
```
perl -nle ' print "$1 $2" if /name=(\w+).*age=(\d+)/' filename
perl -nle "print qq{$1 => $2} while /(\S+)=(\S+)/g" data.txt
```
regex lookahead and lookbehind
```
The lookahead assertion is denoted by (?=regexp) and the lookbehind assertion is denoted by (?<=fixed-regexp).
The negated versions of the lookahead and lookbehind assertions are denoted by (?!regexp) and (?<!fixed-regexp) respectively.
http://perldoc.perl.org/perlretut.html#Looking-ahead-and-looking-behind
```
using perl as grep to search regex in list of files and output matches prepending with filename
```
for i in $(ls -1);do perl -nle 'print $1 if /(\d\d\d\d\d\d)/' ${i} | awk -v X=$i '{print X ":" $0}' ;done
```
or:
```
for i in $(ls -1);do export i ; perl -nle 'print $ENV{i} . ":" . $1 if /(\d\d\d\d\d\d)/' ${i} ;done
```


## using sqlite

preparation:

install sqlite itself:
```  
apt-get install sqlite3
```  
or
```  
yum install sqlite2
```  

install Perl db interface and driver:
(maybe: yum install perl-CPAN)
```  
sudo perl -MCPAN -e shell
install DBI
install DBD::SQLite
```  
test in bash:
```  
perl -e 'use DBI ; print join("\n", DBI->available_drivers() )'
```  

create first db and table:

```  
use strict;
use DBI;

# creates file "mydb1.db":

my $dbh = DBI->connect("dbi:SQLite:dbname=mydb1.db", "", "", { RaiseError => 1} ) or die $DBI::errstr;
$dbh->do("drop table if exists table1");
$dbh->do("create table table1 (id int primary key, myfield1 text, myfield2 int)");
$dbh->do("insert into table1 values(1,'helloworld',10987)");
$dbh->do("insert into table1 values(2,'hellomars',1987)");
$dbh->disconnect();
```  
sql query:
```  
#!/usr/bin/perl

use strict;
use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=mydb1.db", { RaiseError => 1 } ) or die $DBI::errstr;

my $result = $dbh->prepare( "select * from table1 where id=1" );  
$result->execute();

my ($myid, $myfielda, $myfieldb ) = $result->fetchrow();
print "$myid $myfielda $myfieldb\n";

my $columns = $result->{NUM_OF_FIELDS};
print "selection has $columns cols\n";

my $rows = $result->rows();
print "selection has $rows rows\n";

$result->finish();
$dbh->disconnect();
```  

### exiftool - print filename and date taken from JPG

```
#!/usr/bin/perl
use Image::ExifTool;

# specify output format
$OUTFORMAT="normal";      # filename<TAB>date
$OUTFORMAT="datetime";    # filename<TAB>date time
$OUTFORMAT="movecommand"; # mv path-filename date-filename

$exif=new Image::ExifTool;
print $ARGV[0] . "\t";
$exif->ExtractInfo($ARGV[0]);

$date = $exif->GetValue('CreateDate');
# get only time
$time = $date;
$time =~ s/.* (\d\d:\d\d:\d\d)$/$1/ ;
# remove time from date:
$date =~ s/ \d\d:\d\d:\d\d$// ;
# replace : by -
$date =~ s/(\d\d\d\d):(\d\d):(\d\d)$/$1-$2-$3/ ;
$filewithoutpath=$ARGV[0] ;
$filewithoutpath =~ s/.*\/(.*)$/$1/ ;

if ( $date =~ m/\d\d\d\d-\d\d-\d\d/ && ( $OUTFORMAT eq "movecommand" ) ) { 
print "mv $ARGV[0] $date-$filewithoutpath\n";
}
elsif ( $date =~ m/\d\d\d\d-\d\d-\d\d/ && ( $OUTFORMAT eq "normal" ) ) {  
print $ARGV[0] . "\t" . $date . "\n";
}
elsif ( $date =~ m/\d\d\d\d-\d\d-\d\d/ && ( $OUTFORMAT eq "datetime" ) ) {  
print $ARGV[0] . "\t" . $date . " " . $time . "\n";
}
```
