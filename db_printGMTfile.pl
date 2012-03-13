#! /usr/bin/env perl
# Antelope database script -MCW

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$dbname = $ARGV[0];
$outfile = $ARGV[1];
open(FILEOUT, ">" , $outfile)  or die "Can't open $outfile: $!";

@dbo = dbopen("$dbname", "r");
@dbo = dblookup(@dbo, "" , "site" , "", "" );
$nrecords = dbquery(@dbo, "dbRECORD_COUNT");

for ( $dbo[3] = 0; $dbo[3] < $nrecords; $dbo[3]++ ) {
	#($olat,$olon,$omag, $otime) = dbgetv(@dbo,qw(lat lon mb time));
	#$ostrtime = strtime($otime);
	#if ($omag == 0) {
	#print "Event $ostrtime mag 0, changing to 1.5...\n";
	#$omag = 1.5;
	#} #if
	#$omag = $omag/10;
	($lat,$lon,$sta) = dbgetv(@dbo,"lat","lon","sta");
	print FILEOUT "$lon $lat $sta\n";
} #for
