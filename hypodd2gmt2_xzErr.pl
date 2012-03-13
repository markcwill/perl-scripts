#! /usr/bin/env perl
#
# hypodd2gmt2.pl locfile outfile
#  -by Mark 2010-088
#     This takes *.loc AND *.reloc files
#     and outputs only original locs with corresponding
#     relocations
#
# See hypoDD Open File Report by Waldhauser for specs

# NOTES:
# Magnitudes of 0.0 are change to 1.5 so they will show up on a map
#
# This is set up to make a lon-Z file with scaled magnitude and
# error bars for use with psxy error bar specs...

# I always put the Antelope pm in, but it's not needed for this script...
#use lib "$ENV{ANTELOPE}/data/perl/";
#use Datascope;
use Getopt::Std;

#-- Check for valid inputs
$help =  <<"EOF";
USAGE: hypodd2gmt2.pl dir locfile relocfile
 dir - directory where hypoDD.loc and hypoDD.reloc reside
OUTPUT:
 locfile - original locations in GMT x y format
 relocfile - relocations in GMT x y format
EOF

getopts('hs');
$flag = print $help if ($opt_h || @ARGV < 1);



MAIN: { last MAIN if $flag;

$hddDir  = $ARGV[0];
if (@ARGV < 3) {
	$locfile = "gmtlocs1.txt";
	$relfile = "gmtlocs2.txt";
	}
else {
	$locfile = $ARGV[1];
	$relfile = $ARGV[2];
	}
$infile1 = "$hddDir/hypoDD.loc";
$infile2 = "$hddDir/hypoDD.reloc";

open(LOCIN, "<$infile1")  or die "Can't open $infile1: $!";
open(RELIN, "<$infile2")  or die "Can't open $infile2: $!";

open(LOCOUT, ">$locfile")  or die "Can't open $locfile: $!";
open(RELOUT, ">$relfile")  or die "Can't open $relfile: $!";
if ($ARGV[3]){
open(RELSFT, ">$ARGV[3]") or die "Cant' open shiftSC.txt $!";}

# Read in both files, keep track of which id is which by indexing in a hash, keep array of ids
while (<LOCIN>) {
	chomp;    
    ($hid,$lat,$lon,$dep,$x,$y,$z,$dx,$dy,$dz,$yr,$mth,$day,$hr,$mn,$snd,$mag,$nccp,$nccs,$nctp,$ncts,$rcc,$rct,$cid) = split(" ",$_);   
	#$lat  = sprintf('%2.4f',$lat);
	#$lon  = sprintf('%3.4f',$lon);
	$mag = 1.5 if ($mag == 0.0);
	$magscale = $mag/10;
	
	push(@oridL, $hid);
	$depsL{$hid} = $dep;
	$magsL{$hid} = $magscale;
	$xesL{$hid}  = $x/1000;
	$exesL{$hid} = $dx/1000;
	$ezesL{$hid} = $dz/1000;
	}
close(LOCIN);

while (<RELIN>) {
	chomp;    
    ($hid,$lat,$lon,$dep,$x,$y,$z,$dx,$dy,$dz,$yr,$mth,$day,$hr,$mn,$snd,$mag,$nccp,$nccs,$nctp,$ncts,$rcc,$rct,$cid) = split(" ",$_);   
	#$lat  = sprintf('%2.4f',$lat);
	#$lon  = sprintf('%3.4f',$lon);
	
	$mag = 1.5 if ($mag == 0.0);
	$magscale = $mag/10;
	
	push(@oridR, $hid);
	$depsR{$hid} = $dep;
	$magsR{$hid} = $magscale;
	$xesR{$hid}  = $x/1000;
	$exesR{$hid} = $dx/1000;
	$ezesR{$hid} = $dz/1000;
	
	$x += 6000 if $lat < 44.5;
	$dep -= 12;
	$depsS{$hid} = $dep;
	$xesS{$hid} = $x/1000;
	}
close(RELIN);

# Write 'em out, only write origins which were relocated.
foreach $oid (@oridR) {
	print LOCOUT "$xesL{$oid} $depsL{$oid} $magsL{$oid} $exesL{$oid} $ezesL{$oid}\n";
	print RELOUT "$xesR{$oid} $depsR{$oid} $magsR{$oid} $exesR{$oid} $ezesR{$oid}\n";
	if ($ARGV[3]) {
	print RELSFT "$xesS{$oid} $depsS{$oid} $magsR{$oid} $exesR{$oid} $ezesR{$oid}\n";}
	}
close(LOCOUT);
close(RELOUT);
close(RELSFT) if ($ARGV[3]);
}
