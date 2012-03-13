#! /usr/bin/env perl
#
#     -by Mark
# reads a RAW GPS file from cruise and prints out certain info
# Usage:   filename.txt

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$infile = $ARGV[0];
$infile =~ m/(\S+)\.log/;
$filename = $1;
#$outfile = $ARGV[1];
$outfile = "${filename}_LOG.txt";
$depth = 0;
$name = "W0907A";

print "Reading file: $infile...\n\n";
open(FILEIN, "<$infile") or die "Can't open $infile: $!";
open(FILEOUT, ">$outfile") or die "Can't open $outfile: $!";
$numOfTags = 0;

GPSLINE: while(<FILEIN>) { next GPSLINE unless m/^\$GPGGA|^File/;

	if(m/GPGGA/) {
		($gpsTag,$hhmmss,$lat,$latOR,$lon,$lonOR,@therest) = split(",",$_);
		next GPSLINE; }
	else {
		($filetag,$shotnum,$time,$date) = split(" ",$_);}
	
	
	($month, $day,$year) = split("/",$date);
	($hour,$minute,$second) = split(":",$time);
	$lat =~ m/(\d+)(\d\d\.\d+)/;
	$latDeg = $1;
	$latMin = $2;
	#$latDeg = -1*$latDeg if $latOR =~ m/S/;
	
	$lon =~ m/(\d+)(\d\d\.\d+)/;
	$lonDeg = $1;
	$lonMin = $2;
	#$lonDeg = -1*$lonDeg if $lonOR =~ m/W/;
	
	# Convert to julian day...
	$etime = str2epoch("$year-$month-$day $hour:$minute:$second");
	$julday = epoch2str($etime,'%j');
	
	print FILEOUT "$year+$julday:$hour:$minute:$second $shotnum $latOR $latDeg $latMin $lonOR $lonDeg $lonMin $depth $name\n";

	$numOfTags++;
} #GPSLINE

print "Number of time tags: $numOfTags\n\n";

