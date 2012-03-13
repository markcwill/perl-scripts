#! /usr/bin/env perl
#
# db_mergeOBS.pl     -by Mark
# Usage: db_mergeOBS.pl  obs_name
#
# Merges wfdisc "day" tables created by `segy2css`
# to create one wfdisc table for each OBS

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$site_db = $ARGV[0];
$site_db = "all_$site_db";
$table_count = 0;

open(WFLSPIPE, "ls 20*.wfdisc |");
dbcreate("$site_db","css3.0");
@db = dbopen("$site_db", "r+");
@db = dblookup(@db, "" , "wfdisc" , "", "" );
while (<WFLSPIPE>) {
	print "Adding $_"; $table_count++;
	@dbname_parts = split(/\./);
	@db_new = dbopen("$dbname_parts[0]","r");
	@db_new = dblookup(@db_new, "" , "wfdisc" , "", "" );
	$nrecords = dbquery(@db_new, "dbRECORD_COUNT");
	for ( $db_new[3]=0; $db_new[3]<$nrecords; $db_new[3]++ ) {
		$new_rec = dbget(@db_new);
		dbadd(@db,$new_rec);
	}#for
	dbclose(@db_new);
}#while
print "Concatenated $table_count tables into $site_db.\n";
