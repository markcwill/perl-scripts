#! /usr/bin/env perl
# -Mark 2009.303
#
# prints out info on hypocenters from a db
# make sure you have all the tables that dblookup wants
# no error checking in here yet...
#
# prints to stout:
# ID num, date/time, mag, num of stations, num of picks, networks


use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;


$dbname = $ARGV[0];

@db = dbopen("$dbname", "r");
@dbo   = dblookup(@db,"","origin","","");
@dbas  = dblookup(@db,"","assoc","","");
@dbsit = dblookup(@db,"","site","","");
@dbsnt = dblookup(@db,"","snetsta","","");
@dbnet = dblookup(@db,"","network","","");

$nrecords = dbquery(@dbo, "dbRECORD_COUNT");

print "ev   date        time         mag  nst nph nets\n";

# For each origin, calculate num of picks and stations...

#@dbo = dbsubset(@dbo,"orid<100");

for ($dbo[3]=0; $dbo[3]<$nrecords; $dbo[3]++) {
	($olat,$olon,$otime,$odepth,$omag,$orid) = dbgetv(@dbo,qw(lat lon time depth mb orid));
	$odatetime = epoch2str($otime,'%Y %m %d %H %M %S.%s');
	$ostrtime = strtime($otime);
	
	@dbv = dbsubset(@dbo,"orid==$orid");
	@dbv = dbjoin(@dbv,@dbas);
	@dbv = dbseparate(@dbv,"assoc");
	$nph = dbquery(@dbv, "dbRECORD_COUNT");
	@dbv = dbjoin(@dbv,@dbsit,"sta");
	@dbv = dbseparate(@dbv,"site");
	$nst = dbquery(@dbv, "dbRECORD_COUNT");
	@dbv = dbjoin(@dbv,@dbsnt);
	@dbv = dbtheta(@dbv,@dbnet,"snet==net");
	@dbv = dbseparate(@dbv,"network");
	@dbn = dbsort(@dbv,"net");
	$nnt = dbquery(@dbn, "dbRECORD_COUNT");
	
	# generate list of networks...
	@nets = ();  $nctr = 0;
	for ( $dbn[3] = 0; $dbn[3] < $nnt; $dbn[3]++ ) {
		$mynet = dbgetv(@dbn,"net");
		#unless($mynet=~m/IU|UO/){                # exclude 1 station nets
			$nets[$nctr] = $mynet; $nctr++;
		#	}
		}
	printf "%2d  $ostrtime  %1.1f  %2d  %2d  @nets\n",$orid,$omag,$nst,$nph;

}#for
