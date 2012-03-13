#! /usr/bin/env perl
# Antelope database script
#
# changes SAC pick phases to the correct values
# e.g. IUP2 to "P", "c.", "0.2" in the correct fields
# run after creating antelope db from SAC files.

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

@db = dbopen("../db/oreq2", "r+");
@db = dblookup(@db, "" , "arrival" , "", "" );

$nrecords = dbquery(@db, "dbRECORD_COUNT");

for ( $db[3] = 0; $db[3] < $nrecords; $db[3]++ ) {
	$auth = dbgetv(@db,"auth");  # originally in "phase"
	$weight = substr($auth, 3, 1);
	$deltim = dbgetv(@db,"deltim");
	
	if ($weight =~ /\d/) {

	  SWITCH: {	
	    if ($weight == 0) { $weight = 0.05; last SWITCH;  }
	    if ($weight == 1) { $weight = 0.1;  last SWITCH;  }
	    if ($weight == 2) { $weight = 0.2;  last SWITCH;  }
	    if ($weight == 3) { $weight = 0.4;  last SWITCH;  }
	    if ($weight == 4) { $weight = 1.0;  last SWITCH;  }
	  } #switch
	} #if
	else { print "No weight? Delta time is $deltim, rec $db[3]\n"; $weight = $deltim; }

	$deltim = $weight;
	dbputv(@db,"deltim",$deltim);

	if    ($auth =~ /.U/ ) { dbputv(@db, "fm","c.");}
	elsif ($auth =~ /.D/ ) { dbputv(@db, "fm","d.");}
	else  { print "No first motion? $auth\n";}
	
	if ($auth =~ /SAC1/) { dbputv(@db,"iphase","Pg"); }
} #for

