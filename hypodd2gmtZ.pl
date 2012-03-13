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
# This is set up to make a "lon depth magscale" file in UTM coords...
# for a topographic style map with relative sizes for magnitude
# could be changed for a merc map or to include the error bars


#use lib "$ENV{ANTELOPE}/data/perl/";
#use Datascope;
use Getopt::Std;
use Geo::Coordinates::UTM;

#-- Check for valid inputs
$help =  <<"EOF";
Usage: hypodd2gmt [locfile] [>> outfile]
 locfile - hypoDD file './hypoDD.reloc' is default
EOF

getopts('h');
$flag = print "$help" if $opt_h;


MAIN: { last MAIN if $flag;

#-- Command line args --#
#  if no input file, specify hypoDD.reloc

if (@ARGV < 1) {
$infile = "hypoDD.reloc";
#$outfile = $ARGV[0]; 
}
else {
$infile = $ARGV[0];
#$outfile = $ARGV[1]; 
}
#---------------------------------------------------------------------#
$x_corr = 350000; # (+8500 shift from hypoDD)
$y_corr = 4880000;
$z_corr = 0; #km (use 10 without the shift 12 with)

open(FILEIN, "<$infile")  or die "Can't open $infile: $!";
# this doesn't work, flags not available in MacOSX?? check man open(2)
#sysopen(FILEOUT, $outfile, O_EXCL | O_CREAT | O_WRONLY)  or die "Can't open $outfile: $!";
# O_EXCL | O_CREAT | O_WRONLY

while (<FILEIN>) {
	chomp;    
        ($hid,$lat,$lon,$dep,$x,$y,$z,$dx,$dy,$dz,$yr,$mth,$day,$hr,$mn,$snd,$mag,$nccp,$nccs,$nctp,$ncts,$rcc,$rct,$cid) = split(" ",$_);   
		
	#$lat  = sprintf('%2.4f',$lat);
	#$lon  = sprintf('%3.4f',$lon);
	$mag = 1.5 if ($mag == 0.0);
	$magscale = $mag/10;
	($zone,$sx,$sy) = latlon_to_utm("wgs84",$lat,$lon);
	$sx  = ($sx-$x_corr)/1000;
	$sy  = ($sy-$y_corr)/1000;
	$sz  = $dep-$z_corr;	
	printf "%4.4f %3.3f $magscale\n",$sx, $sz;
	}

close(FILEIN);
#close(FILEOUT);
}
