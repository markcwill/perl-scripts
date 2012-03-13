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
$outfile = "station.dat";
open(FILEOUT, ">" , $outfile)  or die "Can't open $outfile: $!";

print "Reading database: $dbname\n";
@dbo = dbopen("$dbname", "r");
@dbo = dblookup(@dbo, "" , "site" , "", "" );
@dbo = dbjoin(@dbo, dblookup(@dbo, "", "snetsta", "" ,""));
$nrecords = dbquery(@dbo, "dbRECORD_COUNT");

for ( $dbo[3] = 0; $dbo[3] < $nrecords; $dbo[3]++ ) {
	($sta, $lat, $lon, $snet) = dbgetv(@dbo,qw(sta lat lon snet));
	print FILEOUT "$sta $lat $lon $snet\n";
}
print "Wrote file: $outfile\n"
