#! /usr/bin/env perl
# Antelope database script
#
# breqfast_expl.pl starttime endtime sta_file label


use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$begtime = $ARGV[0];
$endtime = $ARGV[1];
$stafile = $ARGV[2];		# file with station info
$label = $ARGV[3];		# label of seed file

#$outfile = "iris_req_$label";	# name of email
#$cat_db = "$in_db";	# name of database w/ event info
#$begTimeOff = 60 * 2;		# time before origin (sec)
#$endTimeOff = 60 * 5;		# time after origin (sec)

$startTime = str2epoch($begtime);
$endTime = str2epoch($endtime);
($startyear, $startmonth, $startday, $starthour, $startmin, $startsec) = split(' ',epoch2str($startTime,'%Y %m %d %H %M %S.%s'));
($endyear, $endmonth, $endday, $endhour, $endmin, $endsec) = split(' ',epoch2str($endTime,'%Y %m %d %H %M %S.%s'));

open(FILEIN, "<" , $stafile)  or die "Can't open $stafile: $!";
for ($ctr = 0; <FILEIN>; $ctr++) {
	#($sta[$ctr], $lat[$ctr], $lon[$ctr], $net[$ctr]) = split(' ',$_);
	($sta[$ctr], $net[$ctr]) = split(' ',$_);
	}
close(FILEIN);
  
foreach (0 .. $#sta) {
	$outfile = "iris_req_$sta[$_]_$label";
	open(FILEOUT, ">" , $outfile)  or die "Can't open $outfile: $!";
	print FILEOUT ".NAME Mark Williams\n";
	print FILEOUT ".INST Oregon State University\n" ;
	print FILEOUT ".MAIL 104 COAS Admin, Corvallis, OR 97333\n";
	print FILEOUT ".EMAIL mwilliams\@coas.oregonstate.edu\n" ;
	print FILEOUT ".PHONE 541-737-2847\n" ;
	print FILEOUT ".FAX 541-633-2064\n" ;
	print FILEOUT ".MEDIA Electronic\n" ;
	print FILEOUT ".ALTERNATE MEDIA Electronic\n" ;
	print FILEOUT ".ALTERNATE MEDIA Electronic\n" ;
	print FILEOUT ".LABEL $sta[$_]_$label\n" ;
	print FILEOUT ".END\n\n" ;
	print FILEOUT "$sta[$_] $net[$_] $startyear $startmonth $startday $starthour $startmin $startsec $endyear $endmonth $endday $endhour $endmin $endsec 3 BH? HH? EH?\n";
	close(FILEOUT);
	print "Wrote file: \"$outfile\"\n";
}


$temp = @sta;
print "Generated $temp request email(s).\n"
