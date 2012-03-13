#! /usr/bin/env perl
#
# - by Mark
# converts PNSN catalog format to a CSV file for use with SOD

$help = <<EOF;
Usage: pnsn2csv infile outfile
  infile  - PNSN catalog format
  outfile - CSV format for use with SOD
EOF

if ($ARGV[0]=~ m/-h/ || @ARGV < 1) { $flag = print "$help"; }

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

MAIN: { last MAIN if $flag;

$infile = $ARGV[0];
if ($ARGV[1]) {
	$outfile = $ARGV[1];}
else {$outfile = 'event_list.csv';}

open(FILEIN, "<$infile")  or die "Can't open $infile: $!";
open(FILEOUT, ">$outfile")  or die "Can't open $outfile: $!";

print FILEOUT "time,latitude,longitude,depth,magnitude\n";

while (<FILEIN>) {
	chomp;    
        $yr    = substr($_,2,4);
	$month = substr($_,6,2);
	$day   = substr($_,8,2);
	$hr    = substr($_,10,2);
	$mn    = substr($_,12,2);
	$snd   = substr($_,14,6);
	$latS  = substr($_,21,7);
	$lonS  = substr($_,29,8);
	$dep   = substr($_,37,6);
	$mag   = substr($_,45,3);
	$phasta= substr($_,48,7);
	$gap   = substr($_,56,3);
	$near  = substr($_,59,3);
	$rms   = substr($_,63,4);
	$err   = substr($_,67,5);
	$erD   = substr($_,72,2);
	$mod   = substr($_,75,2);
	
	# seconds may be negative or > 60, so convert to epoch, then add...
	$time = str2epoch("$yr-$month-$day $hr:$mn:00.00") + $snd;
	
	#-- Fix lat,lon and convert to decimal degrees		
	@lats = split(/([NS])/,$latS);
	$lat  = $lats[0]+($lats[2]/6000.0);
	$lat *= -1 if $lats[1] =~ m/S/;
	$lat  = sprintf('%2.4f',$lat);
	
	@lons = split(/([WE])/,$lonS);
	$lon  = $lons[0]+($lons[2]/6000.0);
	$lon *= -1 if $lons[1] =~ m/W/; 
	$lon  = sprintf('%3.4f',$lon);
	
	$timestr = epoch2str($time,'%Y-%m-%dT%H:%M:%S.%sZ');
	
	print FILEOUT "$timestr,$lat,$lon,$dep,$mag\n";
	}
close(FILEIN);
close(FILEOUT);
}
	
