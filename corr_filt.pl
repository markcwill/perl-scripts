#! /usr/bin/env perl

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$mycut = 0.85;
$olddb = $ARGV[0];
$newdb = $ARGV[1];
system("dbcp $olddb $newdb");
@db = dbopen("$newdb", "r+");
@dba = dblookup(@db,"","arrival","","");
@dbas = dblookup(@db,"","assoc","","");
@dbv = @dbas;
$nrecs = dbquery(@dba,"dbRECORD_COUNT");

# go through picks
for($dba[3]=0;$dba[3]<$nrecs;$dba[3]++) {
	($cor_val,$arid) = dbgetv(@dba,"snr","arid");
	if ($cor_val < $mycut) {
		dbputv(@dba,"iphase","A");
		$dbv[3] = dbfind(@dbas,"arid==$arid",-1);
		dbputv(@dbv,"phase","A");		
	}
}

# just changing the phase, you could leave the assoc, origin tables alone...
# hopefully, it locs by 'iphase' and not assoc's 'phase'... compare
# the 'ndef' field in the 'origin' table to verify this...
