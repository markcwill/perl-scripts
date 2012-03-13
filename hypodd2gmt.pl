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

use Getopt::Std;

$help =  <<"EOF";
Usage: hypodd2gmt [locfile] [>> outfile]
 locfile - hypoDD file './hypoDD.reloc' is default
EOF

getopts('h');
$flag = print "$help" if $opt_h;

MAIN: { last MAIN if $flag;

#  if no input file, specify hypoDD.reloc
if (@ARGV < 1) {
	$infile = "hypoDD.reloc";
}
elsif (-d $ARGV[0]) {
	$infile = "$ARGV[0]/hypoDD.reloc";
}
else {
	$infile = $ARGV[0];
}

open(FILEIN, "<$infile")  or die "Can't open $infile: $!";
# this doesn't work, flags not available in MacOSX?? check man open(2)
#sysopen(FILEOUT, $outfile, O_EXCL | O_CREAT | O_WRONLY)  or die "Can't open $outfile: $!";

while (<FILEIN>) {
	chomp;    
    ($hid,$lat,$lon,$dep,$x,$y,$z,$dx,$dy,$dz,$yr,$mth,$day,$hr,$mn,$snd,$mag,$nccp,$nccs,$nctp,$ncts,$rcc,$rct,$cid) = split(" ",$_);   
		
	#$lat  = sprintf('%2.4f',$lat);
	#$lon  = sprintf('%3.4f',$lon);
	$mag = 1.5 if ($mag == 0.0);
	$magscale = $mag/10;
		
	print "$lon $lat $magscale\n";
	}
close(FILEIN);
} # MAIN
