#! /usr/bin/env perl
#
# inputANSS2db.pl locfile cat_db
#  -by Mark 2012
#     takes line catalog info from ANSS easy catalog results
#     and writes to origin, origerr and event tables 
#     in a Datascope database

# NOTE should implement the CNSS standard raw format but for
# now this will work perfectly...


use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

#-- Check for valid inputs
$help =  <<"EOF";
Usage: anss2db [file] out_db
 file   - ANSS screen search format
 out_db - database to write origins
EOF


if (@ARGV < 1 || $ARGV[0] =~ m/-h/) { $flag = print "$help"; }


MAIN: { last MAIN if $flag;

#-- Command line args --#
$infile = $ARGV[0];
$cat_db = $ARGV[1]; 


#-- set parameters
open(FILEIN, "<" , $infile)  or die "Can't open $infile: $!";

@db    = dbopen("$cat_db", "r+");
@dborg = dblookup(@db, "" , "origin" , "", "" );
@dberr = dblookup(@db, "" , "origerr" , "", "" );
@dbevt = dblookup(@db, "" , "event" , "" , "" );

# punt the first two header lines...
<FILEIN>;
<FILEIN>;

while (<FILEIN>) {
	chomp;    
    ($date1,$time1,$lat,$lon,$dep,$mag,$mtype,$nsta,$gap,$closest,$rms,$src,$id) = split(" ",$_);
	$date1 =~ s/\//\-/g;
	$time = str2epoch("$date1 $time1");
	# unecessary in this case, but usually a good idea, Antelope only takes 4 places
	$lat  = sprintf('%2.4f',$lat);
	$lon  = sprintf('%3.4f',$lon);
		
	#-- Add records to origin, origerr, event tables
	$orid = dbnextid(@db,"orid");
	$dborg[3] = dbaddv(@dborg,"orid",$orid,"time",$time,"lat",$lat,"lon",$lon,"depth",$dep,"ml",$mag,"nass",$nsta,"ndef",$nsta,"auth",$src);
	#$orid = dbgetv(@dborg,"orid");
	# no error info for this format, so... stub it out
	# for origerr table, only 'orid' is in the primary key (!), so have to kick a NULL check out
	# to the calling code when pulling out error info... sorry Future Mark.
	dbaddv(@dberr,"orid",$orid,"sdobs",$rms);
	dbaddv(@dbevt,"prefor",$orid);
	print "Added $date1 $time1 <$lat, $lon> M $mag to $cat_db\n";
	}

dbclose(@db);
close(FILEIN);
}
