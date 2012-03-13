#! /usr/bin/env perl
# Antelope database script -MCW

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$dbname = $ARGV[0];
$outfile = $ARGV[1];
open(FILEOUT, ">" , $outfile)  or die "Can't open $outfile: $!";

@db = dbopen("$dbname", "r");
@dbe = dblookup(@db, "" , "event" , "", "" );
@dbo = dblookup(@db, "" , "origin" , "", "" );
@dbv = dbjoin(@dbe,@dbo);
$nrecords = dbquery(@dbv, "dbRECORD_COUNT");

for ( $dbv[3] = 0; $dbv[3] < $nrecords; $dbv[3]++ ) {
	($olat,$olon,$odep, $otime) = dbgetv(@dbv,qw(lat lon depth time));
	$ostrtime = strtime($otime);
	#if ($omag == 0) {
	#print "Event $ostrtime mag 0, changing to 1.5...\n";
	#$omag = 1.5;
	#} #if
	#$omag = $omag/10;
	
	#print FILEOUT "$ostrtime: $olat $olon $odep\n";
	print FILEOUT "$olon $olat $odep\n";
} #for
