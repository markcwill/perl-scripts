#! /usr/bin/env perl
# Antelope database script
#

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$infile = $ARGV[0];

open(FILEIN, "<" , $infile)  or die "Can't open $infile: $!";

# create a dataless master db "temp"
# make sure it links to the responses...

system("rm -r tempwf");
system("mkdir tempwf");

dbcreate("colza","css3.0","../dbmaster");

@db = dbopen("colza", "r+");
@dbmeas = dblookup(@db,"","wfmeas","","");
@dbsta = dblookup(@db,"","sitechan","","");

PARSE: while (<FILEIN>) {     next PARSE if (m/^\./);
        chomp;
	($sta,$net,$startyear,$startmonth,$startday,$starthour,$startmin,$startsec,$endyear,$endmonth,$endday,$endhour,$endmin,$endsec,$nchan,@chans) = split(/ /,$_);
	next PARSE unless ($net =~ m/XA|XN/); #print "Line is $_\n";
	@dbsich = dbsubset(@dbsta,"sta =~/$sta/");
	$time = str2epoch("$startyear-$startmonth-$startday $starthour:$startmin:$startsec");
	$endtime = str2epoch("$endyear-$endmonth-$endday $endhour:$endmin:$endsec");
	
	# some type of filtering... have to process the channel-location stuff...
	
	foreach $newch (@chans) { #print "$sta-$newch\n";
		$newch =~ s/\?+/\.\*/; #print "New channel name: $newch\n";
		@dbchan = dbsubset(@dbsich,"chan =~/$newch/");
		$nrecs = dbquery(@dbchan,"dbRECORD_COUNT");
		#print "Number recs: $nrecs\n";
		for($dbchan[3]=0;$dbchan[3]<$nrecs;$dbchan[3]++) {  
			# go through the channels and put a sta-chan-time-endtime into the wfmeas table...
			$chan = dbgetv(@dbchan,"chan");
			dbaddv(@dbmeas,"sta",$sta,"chan",$chan,"time",$time,"endtime",$endtime,"meastype","trexcerpt","filter","none");
			#print "$sta-$chan $time to $endtime\n";
		}

	}
}
close FILEIN;
dbclose(@db);
# use trexcerpt in explicit mode to cut waveforms using  wfmeas and store in temp folder...
$run_trexc = "trexcerpt -o sd -m explicit -w 'tempwf/%' -W ../db/colza -d -v colza.wfmeas myseed >& my_trexc.err";
system($run_trexc);
# this works up to this point...

# need to combine the resulting db junk/myseed and junk/colza with dbmaster/colza to get the full db then do responses...
