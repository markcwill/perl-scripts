#! /usr/bin/env perl 
#
# by Mark
#


#use Getopt::Std;
#use Geo::Distance;
#use Time::Local;
use Date::Manip;

$infile = '/Users/annetrehu/Projects/W0907A/W0907A_SHOTS.txt';
open(SHOTFILE,"<$infile") or die("Can't open shotfile");
while(<SHOTFILE>) {
	($time,$shotnum,$ns,$latd,$latm,$ew,$lond,$lonm,$foo,$cruise) = split(" ",$_);
	$latm /= 100;
	$latd *= -1 if $ns =~ /S/;
	$lonm /= 100;
	$lond *= -1 if $ew =~ /W/;
	$dep = 0.0;
	($yearday,$hr,$mn,$sc) = split(/:/,$time);
	($yr,$julday) = split(/\+/,$yearday);
	$mh = UnixDate("$yr$julday",'%m');
	$dy = UnixDate("$yr$julday",'%d');
	
	
	printf("%4d %02d %02d %02d %02d %02.4f %2d %02.4f %3d %02.4f %d\n", $yr,$mh,$dy,$hr,$mn,$sc,$latd,$latm,$lond,$lonm,$shotnum);
}
close(SHOTFILE);