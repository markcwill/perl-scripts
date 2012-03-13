#! /usr/bin/env perl
#
# one-off to read SOSUS files... may be custom jobbed
# or heavily modified to not work as advertised by yours truly.

use Getopt::Std;

$help =  <<"EOF";
Usage: sosus2gmt [locfile] [>> outfile]
 locfile - file in SOSUS-like format
EOF

getopts('h');
$flag = print "$help" if $opt_h;

MAIN: { last MAIN if $flag;
#  if no input file, specify hypoDD.reloc
if (@ARGV < 1) {
	die "Need an input file!!";
    }
else {
	$infile = $ARGV[0];
    }
open(FILEIN, "<$infile")  or die "Can't open $infile: $!";
# this doesn't work, flags not available in MacOSX?? check man open(2)
#sysopen(FILEOUT, $outfile, O_EXCL | O_CREAT | O_WRONLY)  or die "Can't open $outfile: $!";

while (<FILEIN>) {
	chomp;    
    ($datetime, $nsta, $stastr, $lat, $lon, $ncol1, $ncol2, $ncol3, $ncol4, $ncol5) = split(" ",$_);
	print "$lon $lat\n";
	}
close(FILEIN);
} # MAIN
