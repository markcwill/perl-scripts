#! /usr/bin/env perl
# Antelope database script -MCW

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$dbname = $ARGV[0];
$table = $ARGV[1];
if ($ARGV[2]) {$subfilt = $ARGV[2];}

@db = dbopen("$dbname", "r");
@dbo = dblookup(@db, "" , "$table" , "", "" );
if ($table =~ m/event/) {
	@db2 = dblookup(@db,"","origin","","");
	@dbo = dbtheta(@dbo,@db2,"prefor==orid");
	}

if ($table =~ m/origin|event/) {$myz = 'depth';}
if ($table =~ m/site/)   {$myz = 'elev';}
if ($subfilt) {
	@dbo = dbsubset(@dbo,"$subfilt");
	}

$nrecords = dbquery(@dbo, "dbRECORD_COUNT");

for ( $dbo[3] = 0; $dbo[3] < $nrecords; $dbo[3]++ ) {
	#($olat,$olon,$omag, $otime) = dbgetv(@dbo,qw(lat lon mb time));
	#$ostrtime = strtime($otime);
	#if ($omag == 0) {
	#print "Event $ostrtime mag 0, changing to 1.5...\n";
	#$omag = 1.5;
	#} #if
	#$omag = $omag/10;
	
	($olat,$olon,$oz) = dbgetv(@dbo,"lat","lon","$myz");
	print "$olon $olat $oz\n";
} #for