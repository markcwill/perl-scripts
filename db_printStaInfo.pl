#! /usr/bin/env perl
# -Mark 2009.303
#
# prints out info from a db
# make sure you have all the tables that dblookup wants
# no error checking in here yet...
#
# prints to stout:



use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;


$dbname = $ARGV[0];

@db = dbopen("$dbname", "r");
@dbo   = dblookup(@db,"","origin","","");
@dbas  = dblookup(@db,"","assoc","","");
@dbsit = dblookup(@db,"","site","","");
@dbsnt = dblookup(@db,"","snetsta","","");
@dbnet = dblookup(@db,"","network","","");

@dbv = dbjoin(@dbas,@dbsit,"sta");
@dbsit = dbseparate(@dbv,site);

@dbv = dbjoin(@dbsit,@dbsnt);
@dbv = dbsort(@dbv,"snet","sta");
$nrecords = dbquery(@dbv, "dbRECORD_COUNT");



print "net sta ondate offdate lat lon elev\n";

# For each sta, print stats...

#@dbo = dbsubset(@dbo,"orid<100"); # filter I needed...

for ($dbv[3]=0; $dbv[3]<$nrecords; $dbv[3]++) {
	($lat,$lon,$elev,$ondate,$offdate,$sta,$net) = dbgetv(@dbv,qw(lat lon elev ondate offdate sta snet));
	#$odatetime = epoch2str($otime,'%Y %m %d %H %M %S.%s');
	#$ostrtime = strtime($otime);
	if ($offdate == -1) { $offdate = '-'; }

	printf "$net $sta $ondate $offdate %2.4f  %3.4f  %1.3f\n",$lat,$lon,$elev;

}#for
