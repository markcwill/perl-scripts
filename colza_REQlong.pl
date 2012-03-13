#! /usr/bin/env perl
# Antelope database script -MCW 2009.093
#
# colza_REQrecsec.pl breqfast_email
# makes breqfast request 
# of a CSS database (later implement subsets on command line)
#-- New approach --#
# make a temp db that just points to the files
# this prevents writing new temp miniseeds and then deleting them... 
# won't work well for events, b/c files are all in daylong segments...
# trexcerpt is more accurate, maybe write two versions of this code...

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$breq_file = $ARGV[0];
# temp database
$dbdir = "/Volumes/seismo_D1/XA_stations/db";
$dbin = "$dbdir/colza_db";
$dbout = "$dbdir/temp_db";
#`mkdir $tempdir`;

dbopen($dbin,"r");
#@dbt_aff = dblookup(@db, "" , "affiliation" , "", "" );
@dbt_cal = dblookup(@db, "" , "calibration" , "", "" );
@dbt_ins = dblookup(@db, "" , "instrument" , "", "" );
@dbt_net = dblookup(@db, "" , "network" , "", "" );
@dbt_scl = dblookup(@db, "" , "schanloc" , "", "" );
@dbt_sen = dblookup(@db, "" , "sensor" , "", "" );
@dbt_sit = dblookup(@db, "" , "site" , "", "" );
@dbt_stc = dblookup(@db, "" , "sitechan" , "", "" );
@dbt_sns = dblookup(@db, "" , "snetsta" , "", "" );
@dbt_stg = dblookup(@db, "" , "stage" , "", "" );
@dbt_wfd = dblookup(@db, "" , "wfdisc" , "", "" );

open(FILEIN,"<", $breq_file) or die "Can't open $breq_file: $!";
HEADER: while(<FILEIN>) { last HEADER unless m/\.\S+/;
	if (m/\.LABEL\s+(\S+)/) {$label = $1;}
}

# for every request line, extract the info in to a temp database...
$ctr = 0;

REQLINES: while(<FILEIN>) {
($sta,$net,$syr,$smh,$sdy,$shr,$smn,$ssc,$eyr,$emh,$edy,$ehr,$emn,$esc,$num_chan,@chans) = split(" ",$_);
next REQLINES unless $net=~m/XA/;
$sTime = str2epoch("$syr-$smh-$sdy $shr:$smn:$ssc");
$eTime = str2epoch("$eyr-$emh-$edy $ehr:$emn:$esc");
# either make them one by one, or write something to extract everything...
#@chans =~ s/\?/\.\*/g; #ignoring channel reqs right now...

#here, have to join everything that you need to make a SEED, or a whole db
#take subset of sta and time (and maybe chan) then unjoin it into a new db... 
@dbv = dbsubset(@dbwfd, "sta=~/$sta/");
@dbv = dbsubset(@dbv, "chan=~/B.*|H.*/");  # hard coded BB channels, for now...
@dbv = dbsubset(@dbv, "time >= $sTime & time < $eTime"); 

@dbv = dbjoin(@dbv,@dbt_sit);
@dbv = dbjoin(@dbv,@dbt_stc);
@dbv = dbjoin(@dbv,@dbt_sns);
@dbv = dbjoin(@dbv,@dbt_scl);
@dbv = dbjoin(@dbv,@dbt_net);
@dbv = dbjoin(@dbv,@dbt_stg);
@dbv = dbjoin(@dbv,@dbt_sen);
@dbv = dbjoin(@dbv,@dbt_ins);
@dbv = dbjoin(@dbv,@dbt_cal);

dbunjoin(@dbv, $dbout);
}

#--- optionally, try to make a SEED volume, then delete the actual db... ----------#
#@db2sd = ("db2sd","$dbout","$label.seed");
#system(@db2sd);
#'rm $dbdir/temp_db*`:
#----------------------------------------------------------------------------------#

