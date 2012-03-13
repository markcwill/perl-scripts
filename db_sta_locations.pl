#! /usr/bin/env perl
# Antelope database script -MCW
#
# you must have perl package "Datascope.pm"
# the "use lib" line points to where antelope keeps it
#
# Usage: db_mkstadat.pl [my_database]
# script assumes the database is in a directory called "db"


use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$dbname = $ARGV[0];
$outfile = $ARGV[1];
open(FILEOUT, ">" , $outfile)  or die "Can't open $outfile: $!";

print "Reading database: $dbname\n";
@dbo = dbopen("$dbname", "r");
@dbo = dblookup(@dbo, "" , "site" , "", "" );
@dbo = dbjoin(@dbo, dblookup(@dbo, "", "snetsta", "" ,""));
$nrecords = dbquery(@dbo, "dbRECORD_COUNT");

for ( $dbo[3] = 0; $dbo[3] < $nrecords; $dbo[3]++ ) {
	#($sta, $lat, $lon, $elev, $snet) = dbgetv(@dbo,qw(sta lat lon elev snet));
	#print FILEOUT "$sta $lat $lon $elev $snet\n";
	($sta, $lat, $lon, $elev, $snet,$ondate,$offdate) = dbgetv(@dbo,qw(sta lat lon elev snet ondate offdate));
	print FILEOUT "$sta OBS Seismic $ondate $lat $lon $elev surveyed $offdate Anne Trehu\n";	
	
}
print "Wrote file: $outfile\n";


close FILEOUT;
dbclose(@dbo);
