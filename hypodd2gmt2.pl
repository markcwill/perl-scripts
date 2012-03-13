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
# This is set up to make a "lon lat magscale" file
# for a topographic style map with relative sizes for magnitude
# could be changed for a depth style map or to include the error bars

# I always put the Antelope pm in, but it's not needed for this script...
#use lib "$ENV{ANTELOPE}/data/perl/";
#use Datascope;

#-- Check for valid inputs
$help =  <<"EOF";
USAGE: hypodd2gmt2.pl dir locfile relocfile
 dir - directory where hypoDD.loc and hypoDD.reloc reside
OUTPUT:
 locfile - original locations in GMT x y format
 relocfile - relocations in GMT x y format
EOF

if ($ARGV[0] =~ m/-h/) { $flag = print "$help"; }
if (@ARGV < 1)         { $flag = print "$help"; }


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

# Read in both files, keep track of which id is which by indexing in a hash, keep array of ids
while (<LOCIN>) {
	chomp;    
        ($hid,$lat,$lon,$dep,$x,$y,$z,$dx,$dy,$dz,$yr,$mth,$day,$hr,$mn,$snd,$mag,$nccp,$nccs,$nctp,$ncts,$rcc,$rct,$cid) = split(" ",$_);   
	#$lat  = sprintf('%2.4f',$lat);
	#$lon  = sprintf('%3.4f',$lon);
	$mag = 1.5 if ($mag == 0.0);
	$magscale = $mag/10;
	
	push(@oridL, $hid);
	$latsL{$hid} = $lat;
	$lonsL{$hid} = $lon;
	$depsL{$hid} = $dep;
	$magsL{$hid} = $magscale;	
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
	$latsR{$hid} = $lat;
	$lonsR{$hid} = $lon;
	$depsR{$hid} = $dep;
	$magsR{$hid} = $magscale;	
	}
close(RELIN);

# Write 'em out, only write origins which were relocated.
foreach $oid (@oridR) {
	print LOCOUT "$lonsL{$oid} $latsL{$oid} $magsL{$oid}\n";
	print RELOUT "$lonsR{$oid} $latsR{$oid} $magsR{$oid}\n";
	}
close(LOCOUT);
close(RELOUT);
}
