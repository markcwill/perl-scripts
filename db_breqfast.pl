#! /usr/bin/env perl
# Antelope database script
#
# db_breqfast.pl db_name sta_file label
# makes breqfast request for all events in the "origin" table
# of a CSS database (later implement subsets on command line)

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$in_db = $ARGV[0];
$stafile = $ARGV[1];		# file with station info
$label = $ARGV[2];		# label of seed file

$outfile = "iris_req_$label";	# name of email
$cat_db = "$in_db";	# name of database w/ event info
$begTimeOff = 60 * 5;		# time before origin (sec)
$endTimeOff = 60 * 25;		# time after origin (sec)

open(FILEIN, "<" , $stafile)  or die "Can't open $stafile: $!";
open(FILEOUT, ">" , $outfile)  or die "Can't open $outfile: $!";
@db = dbopen($cat_db, "r");

for ($ctr = 0; <FILEIN>; $ctr++) {
	#($sta[$ctr], $lat[$ctr], $lon[$ctr], $net[$ctr]) = split(' ',$_);
	#($sta[$ctr], $net[$ctr]) = split(' ',$_);
	($sta[$ctr], $lat[$ctr], $lon[$ctr], $ele[$ctr], $net[$ctr]) = split(' ',$_);
	}
  

print FILEOUT ".NAME Mark Williams\n";
print FILEOUT ".INST Oregon State University\n" ;
print FILEOUT ".MAIL 104 COAS Admin, Corvallis, OR 97333\n";
print FILEOUT ".EMAIL mwilliams\@coas.oregonstate.edu\n" ;
print FILEOUT ".PHONE 541-737-2847\n" ;
print FILEOUT ".FAX 541-633-2064\n" ;
print FILEOUT ".MEDIA Electronic\n" ;
print FILEOUT ".ALTERNATE MEDIA Electronic\n" ;
print FILEOUT ".ALTERNATE MEDIA Electronic\n" ;
print FILEOUT ".LABEL $label\n" ;
print FILEOUT ".END\n\n" ;

#for all the records...
@db = dblookup(@db, "" , "origin" , "", "" );
$nrecords = dbquery(@db, "dbRECORD_COUNT");

for ( $db[3] = 0; $db[3] < $nrecords; $db[3]++ ) {
	$time = dbgetv(@db,"time");
	$startTime = $time-$begTimeOff;
	$endTime = $time+$endTimeOff;
	($startyear, $startmonth, $startday, $starthour, $startmin, $startsec) = split(' ',epoch2str($startTime,'%Y %m %d %H %M %S.%s'));
	($endyear, $endmonth, $endday, $endhour, $endmin, $endsec) = split(' ',epoch2str($endTime,'%Y %m %d %H %M %S.%s'));
	foreach (0 .. $#sta) {
		print FILEOUT "$sta[$_] $net[$_] $startyear $startmonth $startday $starthour $startmin $startsec $endyear $endmonth $endday $endhour $endmin $endsec 3 BH? HH? EH?\n";
	}
} #for  
$temp = @sta;
print "Generated request called \"$outfile\" for $nrecords events, $temp stations.\n"
