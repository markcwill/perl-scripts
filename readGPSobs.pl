#! /usr/bin/env perl
#
# readGPSobs.pl     -by Mark
# reads a RINEX GPS observation file and prints out certain info
# Usage: readGPSobs.pl  filename.txt

$infile = $ARGV[0];
print "Reading file: $infile...\n\n";
open(FILEIN, "<$infile") or die "Can't open $infile: $!";

HEADER: while(<FILEIN>) { last HEADER if m/END OF HEADER/;

	SWITCH: {
	if (m/REC # \/ TYPE \/ VERS/) {
		$recType = substr($_,20,20); 
		print "Receiver Type: $recType\n";
		last SWITCH;}
	if (m/APPROX POSITION XYZ/)   {
		@approxPosXYZ = split(' ',$_);
		print "Approximate Position: @approxPosXYZ[0..2]\n";
		last SWITCH;}
	if (m/# \/ TYPES OF OBSERV/)  {
		@typeObs = split(' ',$_); 
		print "Observations: $typeObs[0] \nType: @typeObs[1..$typeObs[0]]\n";
		last SWITCH;}
	} #SWITCH
} #HEADER

$numOfTags = 0;

GPSDATA: while(<FILEIN>) {
	$numOfTags++ if m/G/;
} #GPSDATA
print "Number of time tags: $numOfTags\n\n";
