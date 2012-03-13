#! /usr/bin/env perl

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$arid = 1; # CHECK LASTID
open(PIPE, "ls *.txt |");
while(<PIPE>) {
	$pickfile = $_; # just throw it in, for now...
	
@db = dbopen($new_db,"r+");
@dbar = dblookup(@db,"","arrival","","");
@dbas = dblookup(@db,"","assoc","","");
@dbst = dblookup(@db,"","site","","");
@dbo = dblookup(@db,"","origin","","");	
# input the files... get station, maybe line from them...
$sta = "something from $pickfile";
open(FILEIN, "<$pickfile");


while(<FILEIN>) {
($lon,$lat,$dep,$xshot,$ytime) = split(" ",$_);
#round $xshot!!!!!!!!!
$xshot = sprintf('%d',$xshot);
# if the shots are already in there...
@dbo = dbsubset(@dbo,"orid == $xshot");
$shottime = dbgetv(@dbo,"time");
$ytime = $shottime + $ytime;
dbaddv(@dbas,"orid",$xshot,"arid",$arid);
dbaddv(@dbar,"time",$ytime,"arid",$arid);
}

dbaddv(@dbst,"sta",$sta,"lon",$lon,"lat",$lat,"depth",$dep);

}

 


