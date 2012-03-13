#! /usr/bin/env perl
#
# pnsn2db.pl catfile cat_db
#  -by Mark 2009-261
#     takes line catalog info from a Pacific Northwest Seismic Network
#     formatted file and writes to origin, origerr and event tables 
#     in a Datascope database
#
# See http://www.pnsn.org/ for catalog specs

# NOTES:
# can use "split", but it won't always work, so implementing it as a bunch of
# "substr" will keep it from ever breaking on things like negative seconds, or
# triple digit depths and distances...

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$help =  <<"EOF";
Usage: pnsn2db file out_db
 file   - contains locations in PNSN \"A\" format
 out_db - database to write origins
EOF


if (@ARGV < 2) { $flag = print "$help"; }


MAIN: { last MAIN if $flag;

$infile = $ARGV[0];
$cat_db = $ARGV[1];

open(FILEIN, "<" , $infile)  or die "Can't open $infile: $!";

@db    = dbopen("$cat_db", "r+");
@dborg = dblookup(@db, "" , "origin" , "", "" );
@dberr = dblookup(@db, "" , "origerr" , "", "" );
@dbevt = dblookup(@db, "" , "event" , "" , "" );

while (<FILEIN>) {
	chomp;    
    $yr    = substr($_,2,4);
	$month = substr($_,6,2);
	$day   = substr($_,8,2);
	$hr    = substr($_,10,2);
	$mn    = substr($_,12,2);
	$snd   = substr($_,14,6);
	$latS  = substr($_,21,7);
	$lonS  = substr($_,29,8);
	$dep   = substr($_,37,6);
	$mag   = substr($_,45,3);
	$phasta= substr($_,48,7);
	$gap   = substr($_,56,3);
	$near  = substr($_,59,3);
	$rms   = substr($_,63,4);
	$err   = substr($_,67,5);
	$erD   = substr($_,72,2);
	$mod   = substr($_,75,2);
	
	# seconds may be negative or > 60, so convert to epoch, then add...
	$time = str2epoch("$yr-$month-$day $hr:$mn:00.00") + $snd;
	
	#-- Fix lat,lon and convert to decimal degrees		
	@lats = split(/([NS])/,$latS);
	$lat  = $lats[0]+($lats[2]/6000.0);
	$lat *= -1 if $lats[1] =~ m/S/;
	$lat  = sprintf('%2.4f',$lat);
	
	@lons = split(/([WE])/,$lonS);
	$lon  = $lons[0]+($lons[2]/6000.0);
	$lon *= -1 if $lons[1] =~ m/W/; 
	$lon  = sprintf('%3.4f',$lon);
		
	#-- Add records to origin, origerr, event tables
	$dborg[3] = dbaddv(@dborg,"time",$time,"lat",$lat,"lon",$lon,"depth",$dep,"ml",$mag,"auth","pnsn", "ndef", 0,"nass",0);
	$orid = dbgetv(@dborg,"orid");
	dbaddv(@dberr,"orid",$orid,"sdobs",$rms,"smajax",$err,"sdepth",$err);
	dbaddv(@dbevt,"prefor",$orid);
	print "Added $yr-$month/$day $hr:$mn $snd <$lat, $lon> M $mag to $cat_db\n";
	}

dbclose(@db);
close(FILEIN);
}
