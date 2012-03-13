#! /usr/bin/env perl
#
# db_mapOBShdr.pl     -by Mark
# Usage: 
#
# Maps headers to proper sta/chan names using
#  a template file

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$template = $ARGV[1];
$site_db  = $ARGV[0];
$table_count = 0;

@db = dbopen("$site_db", "r+");
@db = dblookup(@db, "" , "wfdisc" , "", "" );

#-- Make hashes from the template file --#
open(TEMP, "<$template");
TEMPLINE: while (<TEMP>) { next TEMPLINE if m/\#|\{|\}/;
	# Read in values
	chomp;
	($head1,$head2) = split();
	($sta1,$chan1,$loc1,$net1,$sps1) = split(":",$head1);
	($sta2,$chan2,$loc2,$net2) = split(":",$head2);
	$chid = sprintf("${chan1}_%3.1f",$sps1);
	
	# Build hashes
	$sta{$sta1} = $sta2;
	$chan{$chid} = $chan2;
	}

#-- Get old sta/chan, replace with new values from hash --#
$nrecs = dbquery(@db, "dbRECORD_COUNT");
for ( $db[3]=0; $db[3]<$nrecs; $db[3]++ ) {
	($dbsta,$dbchan,$dbfs) = dbgetv(@db,"sta","chan","samprate");
	$dbchid = sprintf("${dbchan}_%3.1f",$dbfs);

	dbputv(@db,"sta",$sta{$dbsta},"chan",$chan{"$dbchid"});
	}

close(TEMP);
dbclose(@db);
	

