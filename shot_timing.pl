#! /usr/bin/env perl 
#
# by Mark 2010.265
#

# USAGE
#####################################################################
$help =  <<"EOF";
Usage: shot_timing [-hpx] [-f shotfile]
    -h  print this help
    -s  part of an OBS name to match (depricated)
    -f  the shotfile [W0907A_SHOTS.txt]
    -p  print all the shots
    -x  just print info for a spreadsheet
EOF

#####################################################################

use Getopt::Std;
use Geo::Distance;
use Time::Local

getopts('hs:f:px');
print $help and exit if $opt_h;

MAIN: { 

$Vh2o = 1.5;

if ($opt_f) { $infile = $opt_f;}
else { $infile = '/Users/annetrehu/Projects/W0907A/W0907A_SHOTS.txt';}
$sitetbl = "/Volumes/colza_HD/obs2008/dbmaster/obs2008.site";
$pickfile =  "/Users/annetrehu/Projects/W0907A/shot_picks.txt";

print "OBS     shot  dist(km)   shottime           arrival     obs-calc sp  multiple     drift(s)      drift+1\n" if $opt_x;

# LOOP while loop can be taken out, but this iterates over each line of my pickfile...
open(PICKF, "<$pickfile") or die("Can't open site file...");
LOOP: while(<PICKF>) { next LOOP if m/na/;
	($name,$atime,$tt,$ok,$shotsep,$reftime,$drift_time) = split; #if m/$opt_s/;
	($hr,$mn,$sc) = split(/\:/,$atime);
	$etime = timegm(00,$mn,$hr,1, 0, 0)+$sc;


open(DBSITE, "<$sitetbl") or die("Can't open picks file...");
while(<DBSITE>) { @staline = split if m/$name/; }
close(DBSITE);

$obsname = $staline[0];
($slat,$slon,$selv) = @staline[3..6];
$geo = new Geo::Distance(); #no_units,1
$cl{'dist'} = 999999.0;



open(SHOTFILE,"<$infile") or die("Can't open shotfile");
while(<SHOTFILE>) {
	@shotline = split;
	$lat = $shotline[3]+($shotline[4]/60.0);
	$lat *= -1 if $shotline[2] =~ /S/;
	$lon = $shotline[6]+($shotline[7]/60.0);
	$lon *= -1 if $shotline[5] =~ /W/;
	$dep = 0.0;
	# calculate distance...
	$distance = $geo->distance('kilometer',$lon,$lat => $slon,$slat);
	$dist3d = sqrt($distance**2+(-$dep-$selv)**2);
	if ($dist3d < $cl{'dist'}) {
		$cl{'dist'} = $dist3d;
		$cl{'lat'},$cl{'lon'} = $lat,$lon;
		$cl{'shnum'} = $shotline[1];
		$cl{'time'}  = $shotline[0];
	}
	printf("%d %s %s %.3f\n", $shotline[1],$shotline[0],$name,$dist3d) if $opt_p;
}
close(SHOTFILE);
($yrday,$shr,$smn,$ssc) = split(/\:/,$cl{'time'});
$stime = timegm(00,$smn,$shr,1, 0, 0)+$ssc;
# travel time of shot
$ttime = $etime-$stime;
# obs-calc time difference
$delay =  $ttime-$cl{'dist'}/$Vh2o;

# Print useful info on closest shot, or print out all info in spreadsheet-friendly format
unless ($opt_x) {
	printf "$name Delay from shot: %4d [%2.3f km, %2.2f s] = % 5.3f s Shots spaced %s\n",$cl{'shnum'},$cl{'dist'},$cl{'dist'}/$Vh2o,$delay,$shotsep;
}
else {
	printf "$name %5d  %2.3f    $cl{'time'} $atime  % +5.3f  $shotsep $reftime % +3.8f   % +3.8f\n", $cl{'shnum'},$cl{'dist'},$delay,$drift_time,$drift_time+1.0;
}

} # LOOP
close(PICKF);

} # MAIN
