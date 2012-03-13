#! /usr/bin/env perl
# This is the example perl script from antelope documentation
# except I added the "use lib" line


use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

@db = dbopen("demo", "r");
@db = dblookup(@db, "" , "origin" , "", "" );
@db = dbsubset(@db, "orid == 645");
@db = dbjoin(@db, dblookup(@db, "", "assoc", "" ,""));
@db = dbjoin(@db, dblookup(@db, "", "arrival", "", ""));
@db = dbjoin(@db, dblookup(@db, "", "site", "", ""));
@db = dbsort(@db, "arrival.time");

$nrecords = dbquery(@db, "dbRECORD_COUNT");

for ( $db[3] = 0; $db[3] < $nrecords; $db[3]++ ) {
	($sta, $time, $delta, $phase) = dbgetv(@db, qw(sta arrival.time assoc.delta assoc.phase));
	print "$sta $time $delta $phase\n" ;
}
