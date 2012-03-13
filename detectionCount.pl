#! /usr/bin/env perl 
#
# by Mark 2010.278
#

# USAGE
#####################################################################
$help =  <<"EOF";
Usage: detectionCount.pl
    -h  print this help
EOF

#####################################################################

use Getopt::Std;
#use Geo::Distance;
#use Time::Local;

getopts('h');
print $help and exit if $opt_h;

$dbdir   = "/Volumes/colza_HD/obs2007/detect/obs2007";
$sitetbl = "$dbdir.site";
$decttbl = "$dbdir.detection";

open(DBSITE, "<$sitetbl") or die("Can't open site file...");
while(<DBSITE>) { 
	@staline = split; 

$obsname = $staline[0];
$rec{$obsname} = { lat => $staline[3],
	           lon => $staline[4],
		   elv => $staline[5]
		 };
}
close(DBSITE);

print "STA     Depth   # of Det\n";
foreach $obs (keys %rec) {
	$count = 0;
	open(DBDECT, "<$decttbl") or die("Can't open detection file...");
	while(<DBDECT>) {
		$count++ if ( m/$obs/ && m/D/ );
	}
	$rec{$obs}{detections} = $count;
	close(DBDECT);
	
	if ($rec{$obs}{detections}){
	print "$obs $rec{$obs}{elv}  $rec{$obs}{detections}\n";
	}
}
		

