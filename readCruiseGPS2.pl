#! /usr/bin/env perl
#
#     -by Mark
# reads a RAW GPS file from cruise and prints out certain info
# Usage:   filename.txt

$infile = $ARGV[0];
$infile =~ m/(\S+)\.RAW/;
$filename = $1;
#$outfile = $ARGV[1];
$outfile = "${filename}.txt";

print "Reading file: $infile...\n\n";
open(FILEIN, "<$infile") or die "Can't open $infile: $!";
open(FILEOUT, ">$outfile") or die "Can't open $outfile: $!";
$numOfTags = 0;

GPSLINE: while(<FILEIN>) { 

	($date,$time,$gpsTag,$hhmmss,$lat,$latOR,$lon,$lonOR) = split(",",$_);
	($month, $day,$year) = split("/",$date);
	($hour,$minute,$second) = split(":",$time);
	$lat =~ m/(\d+)(\d\d\.\d+)/;
	$latDeg = $1;
	$latMin = $2;
	$latDeg = -1*$latDeg if $latOR =~ m/S/;
	
	$lon =~ m/(\d+)(\d\d\.\d+)/;
	$lonDeg = $1;
	$lonMin = $2;
	$lonDeg = -1*$lonDeg if $lonOR =~ m/W/;
	print FILEOUT "$year $month $day $hour $minute $second $latDeg $latMin $lonDeg $lonMin\n";

$numOfTags++ if m/G/;
} #GPSLINE

print "Number of time tags: $numOfTags\n\n";
