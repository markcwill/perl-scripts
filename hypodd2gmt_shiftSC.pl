#! /usr/bin/env perl
#
# hypodd2gmt.pl locfile outfile
#  -by Mark 2009-274
#     takes line catalog info from hypoDD reloc file
#     and writes to standard out for use with GMT
#
# See hypoDD Open File Report by Waldhauser for specs

# NOTES:
# Magnitudes of 0.0 are change to 1.5 so they will show up on a map
#
# This is set up to make a "lon lat magscale" file
# for a topographic style map with relative sizes for magnitude
# could be changed for a depth style map or to include the error bars


use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

#-- Check for valid inputs
$help =  <<"EOF";
Usage: hypodd2gmt [locfile] [>> outfile]
 locfile - hypoDD file 'hypoDD.reloc' is default
EOF

if ($ARGV[0] =~ m/-h/) { $flag = print "$help"; }


MAIN: { last MAIN if $flag;

#-- Command line args --#
#  if no input file, specify hypoDD.reloc

if (@ARGV < 1) {
$infile = "hypoDD.reloc";
}
else {
$infile = $ARGV[0];
}

open(FILEIN, "<$infile")  or die "Can't open $infile: $!";

$scale = 10;
$offlon = -124.474-(-124.406);

while (<FILEIN>) {
	chomp;    
    ($hid,$lat,$lon,$dep,$x,$y,$z,$dx,$dy,$dz,$yr,$mth,$day,$hr,$mn,$snd,$mag,$nccp,$nccs,$nctp,$ncts,$rcc,$rct,$cid) = split(" ",$_);   
		
	$mag = 1.5 if ($mag == 0.0);
	$magscale = $mag/$scale;
	$lon -= $offlon if ($lat < 44.5);	
	print "$lon $lat $magscale\n";
	}

close(FILEIN);
}
