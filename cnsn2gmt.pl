#! /usr/bin/env perl
#
# This is for CNSN catalog data from the Canadian website.
# could match for year, month, day, and split time, but this is
# just for a GMT file...

use Getopt::Std;

$help =  <<"EOF";
Usage: cnsn2gmt [locfile] [>> outfile]
 locfile - text file from Canadian National Seismic Network
EOF

getopts('h');
$flag = print "$help" if $opt_h;

MAIN: { last MAIN if $flag;
#  if no input file....
if (@ARGV < 1) {
	die "Need an input file!!";
    }
else {
	$infile = $ARGV[0];
    }

open(FILEIN, "<$infile")  or die "Can't open $infile: $!";
# first 3 are header lines, could just toss 1,2,3, but they stick in
# a URL on the last line, so just reject any line that doesn't match
# the date format...
while (<FILEIN>) {
	chomp;    
    ($date, $time, $lat, $lon, $depth, $mag, $locstring) = split(" ",$_);
    next unless $date =~ m/\d{4}\/\d{2}\/\d{2}/;
    $mag =~ m/(\d\.\d)\w+/;
    $mag_scaled = $1/20.;
	print "$lon $lat $mag_scaled\n";
	}
close(FILEIN);
} # MAIN
