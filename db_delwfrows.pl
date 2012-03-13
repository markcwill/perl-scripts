#! /usr/bin/env perl
# by Mark 2009.295
# Deletes rows from a wfdisc table

# modify to mark/delete anything from any table
# BUT, have to use perl REGEX, not the antelope one (for now)

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;


$input1 = $ARGV[0]; # not used yet, 'stub'
$dbname = $ARGV[1];

@db = dbopen("$dbname", "r+");
@dbwf = dblookup(@db, "" , "wfdisc" , "", "" );

$nrecs = dbquery(@dbwf, "dbRECORD_COUNT");
for ( $dbwf[3] = 0; $dbwf[3] < $nrecs; $dbwf[3]++ ) {
	# deletes LH? channel rows
	#if (dbgetv(@dbwf,"chan") =~ m/^L/) {dbmark(@dbwf);}
	# gets rid of the last n rows (20759)
	if ($dbwf[3] >= $input1) {dbmark(@dbwf);}
}	
dbcrunch(@dbwf);
$wfrecs2 = dbquery(@dbwf, "dbRECORD_COUNT");
print "Number of recs: before: $nrecs... after: $wfrecs2\n";
