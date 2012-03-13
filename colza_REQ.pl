#! /usr/bin/env perl
# Antelope database script -MCW 2009.093
#
# colza_REQrecsec.pl breqfast_email
# makes breqfast request 
# of a CSS database (later implement subsets on command line)
#
# This version cuts out the exact timelength of files reqested,
# but makes copies of the data, which must be deleted...
# More accurate, less efficient... 

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

# temp database
$breq_file = $ARGV[0];
$tempdir = "/Volumes/seismo_D1/XA_stations/temporaryDBdir";
$dbdir = "/Volumes/seismo_D1/XA_stations/db";
$dbin = "$dbdir/colza_db";
$dbout = "$dbdir/temp_db";
`mkdir $tempdir`;

open(FILEIN,"<", $breq_file) or die "Can't open $breq_file: $!";

# just pull the label from the header...

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
@trexcp = ("trexcerpt","-c \"sta=~/$sta/ & chan=~/B.*|H.*/\"", "-dE", "$dbin","$dbout","$sTime","$eTime");
system(@trexcp);

}
@db2sd = ("db2sd","$dbout","$label.seed");
system(@db2sd);
#`rm -r $tempdir`;
#then take the temp db, write it to a SEED, and delete it...

