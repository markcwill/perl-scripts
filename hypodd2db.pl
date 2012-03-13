#! /usr/bin/env perl
#
# hypodd2db.pl locfile cat_db
#  -by Mark 2009-261
#     takes line catalog info from hypoDD reloc file
#     and writes to origin, origerr and event tables 
#     in a Datascope database
#
# See hypoDD Open File Report by Waldhauser for specs

# NOTES:
# needs to be changed to accomodate existing databases
# right now, it will just add to existing events, wont
# check to see if they are already there, can fix this
# by eventually checking for the existance of the "event"
# table, and assuming evid == orid == cusp for the pre-located events


use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

#-- Check for valid inputs
$help =  <<"EOF";
Usage: hypodd2db [file] out_db
 file   - hypoDD file 'hypoDD.reloc' format
 out_db - database to write origins
EOF


if (@ARGV < 1 || $ARGV[0] =~ m/-h/) { $flag = print "$help"; }


MAIN: { last MAIN if $flag;

#-- Command line args --#
#  if no input file, specify hypoDD.reloc
# THIS IS A QUICK FIX, 
# CAN DESTROY THINGS BY INCORRECT USE!!
if (@ARGV < 2) {
$infile = "hypoDD.reloc";
$cat_db = $ARGV[0]; }
else {
$infile = $ARGV[0];
$cat_db = $ARGV[1]; 
}

#-- set parameters
open(FILEIN, "<" , $infile)  or die "Can't open $infile: $!";

@db    = dbopen("$cat_db", "r+");
@dborg = dblookup(@db, "" , "origin" , "", "" );
@dberr = dblookup(@db, "" , "origerr" , "", "" );
@dbevt = dblookup(@db, "" , "event" , "" , "" );

while (<FILEIN>) {
	chomp;    
        ($hid,$lat,$lon,$dep,$x,$y,$z,$dx,$dy,$dz,$yr,$mth,$day,$hr,$mn,$snd,$mag,$nccp,$nccs,$nctp,$ncts,$rcc,$rct,$cid) = split(" ",$_);   
		
	$time = str2epoch("$yr-$mth-$day $hr:$mn:00.00") + $snd;
	
	$lat  = sprintf('%2.4f',$lat);
	$lon  = sprintf('%3.4f',$lon);
		
	#-- Add records to origin, origerr, event tables
	$dborg[3] = dbaddv(@dborg,"time",$time,"lat",$lat,"lon",$lon,"depth",$dep,"ml",$mag,"auth","hypoDD");
	$orid = dbgetv(@dborg,"orid");
	dbaddv(@dberr,"orid",$orid,"sdobs",$rct,"smajax",$dx/1000,"sminax",$dy/1000,"sdepth",$dz/1000);
	#dbaddv(@dbevt,"prefor",$orid);
	print "Added $yr-$month/$day $hr:$mn $snd <$lat, $lon> M $mag to $cat_db\n";
	}

dbclose(@db);
close(FILEIN);
}
