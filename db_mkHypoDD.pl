#! /usr/bin/env perl
# Antelope database script -MCW
#
# Usage: db_mkHypoDD.pl [my_database]
# script assumes the database is in a directory called "db"
#
# NOTE: this is not the latest version, the one on the SUN parses error values...


use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$dbname = $ARGV[0];
$outfile = "hdd_picks.dat";
open(FILEOUT, ">" , $outfile)  or die "Can't open $outfile: $!";

print "Reading database: ./db/$dbname\n";
@dbo = dbopen("db/$dbname", "r");
@dbo = dblookup(@dbo, "" , "origin" , "", "" );
$nrecords = dbquery(@dbo, "dbRECORD_COUNT");

for ( $dbo[3] = 0; $dbo[3] < $nrecords; $dbo[3]++ ) {
	($olat,$olon,$otime,$odepth,$omag,$orid) = dbgetv(@dbo,qw(lat lon time depth mb orid));
	$odatetime = epoch2str($otime,'%Y %m %d %H %M %S.%s');
	$ostrtime = strtime($otime);
	print FILEOUT "# $odatetime $olat $olon $odepth $omag 0 0 0 $orid\n";
	
	@db = dbsubset(@dbo,"orid==$orid");
	@db = dbjoin(@db, dblookup(@db, "", "assoc", "" ,""));
	@db = dbjoin(@db, dblookup(@db, "", "arrival", "", ""));
	
	$nassoc = dbquery(@db, "dbRECORD_COUNT");
	
	for ( $db[3] = 0; $db[3] < $nassoc; $db[3]++ ) {
		($sta, $arrtime, $deltim, $iphase) = dbgetv(@db, qw(sta arrival.time deltim iphase));
	
		if ($sta =~ /TAKO/ || $sta =~ /MEGW/) {
			print "Removed sta $sta from event $orid.\n";}
		else {
			$travtim = $arrtime-$otime;
			$phase = substr($iphase,0,1);
			$weight = $deltim;
		
	  		SWITCH: {	
	    		if ($weight <= 0.05) { $weight = 1.00;  last SWITCH;}
	    		if ($weight <= 0.1)  { $weight = 0.50;  last SWITCH;}
	    		if ($weight <= 0.2)  { $weight = 0.25;  last SWITCH;}
	    		if ($weight <= 0.4)  { $weight = 0.12;  last SWITCH;}
	    		else                 { $weight = 0.00;  last SWITCH;}
	  		} #switch
	  
			printf FILEOUT "$sta %2.3f $weight $phase\n" ,$travtim;
		} #else
	}#for
}#for
print "Wrote hypoDD pickfile: $outfile\n"



