#! /usr/bin/env perl

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$shotfile = $ARGV[0];
$new_db = $ARGV[1]; print "$new_db\n";
dbcreate("db/$new_db","css3.0");
#open(PIPE, "ls *.csv |");
#while(<PIPE>) {
#$shotfile = $_; # just throw it in, for now...

	
# input the files... get station, maybe line from them...
open(FILEIN, "<or96_nav/$shotfile");
@db = dbopen("db/$new_db","r+");
@dbo = dblookup(@db,"","origin","","");

while(<FILEIN>) {
if (m/shot/) { @headers = split(" ",<FILEIN>);} # disregard header labels
else {
$shotorigin = $_;
($shotnmb,$timestr,$delay,$lon,$lat,$elev,$dep) = split(" ",$shotorigin);
$elev = substr($_,54,3);
$dep = substr($_,57,6);
$time = str2epoch("19$timestr");
print "$shotnmb $time $elev $dep\n";
dbaddv(@dbo,"orid",$shotnmb,"time",$time,"lon",$lon,"lat",$lat,"depth",$dep/1000);
}}
close(FILEIN);
dbclose(@db);


