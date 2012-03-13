#! /usr/bin/env perl
# Antelope database script
#
# breqfast_day.pl starttime endtime sta_file label


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
$ctr = 0;

$startTime = str2epoch($begtime);
$endTime = str2epoch($endtime);
($startyear, $startday) = split(' ',epoch2str($startTime,'%Y %j'));
($endyear, $endday) = split(' ',epoch2str($endTime,'%Y %j'));

open(FILEIN, "<" , $stafile)  or die "Can't open $stafile: $!";
for ($ctr = 0; <FILEIN>; $ctr++) {
	#($sta[$ctr], $lat[$ctr], $lon[$ctr], $net[$ctr]) = split(' ',$_);
	($sta[$ctr], $net[$ctr]) = split(' ',$_);
	}
close(FILEIN);

for ($whatday = $startday; $whatday <= $endday; $whatday++) {
$sTime = str2epoch("$startyear-$whatday");
$whatday2 = $whatday+1;
$eTime = str2epoch("$startyear-$whatday2");
($year1, $month1, $day1, $hour1, $min1, $sec1) = split(' ',epoch2str($sTime,'%Y %m %d %H %M %S.%s'));
($year2, $month2, $day2, $hour2, $min2, $sec2) = split(' ',epoch2str($eTime,'%Y %m %d %H %M %S.%s'));  
foreach (0 .. $#sta) {
	$outfile = "iris_req_$sta[$_]_${year1}${whatday}";
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
	print FILEOUT ".LABEL $sta[$_]_${year1}${whatday}\n" ;
	print FILEOUT ".END\n\n" ;
	print FILEOUT "$sta[$_] $net[$_] $year1 $month1 $day1 $hour1 $min1 $sec1 $year2 $month2 $day2 $hour2 $min2 $sec2 3 BHZ HHZ EHZ\n";
	close(FILEOUT);
	print "Wrote file: \"$outfile\"\n";
	$ctr++;
}

}

$temp = @sta;
print "Generated $ctr request email(s) for $temp stations.\n"
