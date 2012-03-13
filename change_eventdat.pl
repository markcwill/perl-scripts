#! /usr/bin/env perl
# -by Mark 2010.256
# takes hypoDD file "event.dat" and prints to stdout
#
# the version changes the depth to 15.0 km across the board
# could compare the lat (4?) to make N and S different...
#
# it will not be as nicely formatted as the original file
# (created by ph2dt, but it should still work fine w/hypoDD
$new = $ARGV[0] or die "Enter a new depth in km\n";
$infile = "event.dat";
open(FILEIN,"<$infile") or die "Can't open input file $!";
#open(FILEOUT,">event.dat.new" or die "Can't open outfile $!";
while(<FILEIN>) {
	chomp;
	@evline = split /(\s+)/;
	# change the depth
	@evline[8] = "$new";
	print @evline,"\n";
}
close(FILEIN);
