#! /usr/bin/env perl
# -by Mark
#
# script to input the Gerdom inline data into
# the database for shotline 7, based on db_inputOR96picks.pl
#
# input is individual files for each station "{sta}.tx.in"
# pass it some db with shot line 7 info in it...
#
# This is set up to search for shots by comparing Gerdom x positions to shot longitudes, it
# will probably work for a merged database (7, 8 & 9) too, with the tree search it
# should take almost the same amount of time either way...

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;
use Geo::Coordinates::UTM;

$dbin  = $ARGV[0];
@db    = dbopen($dbin,"r+");
@dbar  = dblookup(@db,"","arrival","","");
@dbas  = dblookup(@db,"","assoc","","");
@dbst  = dblookup(@db,"","site","","");
@dbo   = dblookup(@db,"","origin","","");
@dbo   = dbsort(@dbo,"lon"); # IMPORTANT! have to sort shots to do a 1-D tree search

$totalpicks = 0;

open(PIPE, "ls *.tx.in |") or die("Çan't open pipe, $!");
SFPIPE: while(<PIPE>) {
	$pickfile = $_; chomp($pickfile);
	
	if (m/(\w+)\.tx\.in/) { $sta = $1; }
	else { 
		print "Can't match a station: $sta ??\n";
		next SFPIPE;
	}
	
	open(FILEIN, "<$pickfile") or die "Can't open $pickfile, $!";
	$count = 0;
	PICK: while(<FILEIN>) { 
		
		($xdist,$ytime,$uncert,$layer) = split(" ",$_);
		next PICK if ($ytime<=0);
		
		# trying a binary search tree, more elegant...
		# and I guess about 100 times faster...
		$iter  = 0;
		$found = 0;
		$flag  = 0;
		$nrec  = dbquery(@dbo,"dbRECORD_COUNT");
		$n1    = 0;
		$n2    = $nrec-1;
		$dmin  = 999999;
		$nmin  = 0;
		TREE: until($found) { $iter++;
			$n = sprintf('%.0f',($n2-$n1)/2)+$n1;
			$dbo[3] = $n;
			($olat,$olon) = dbgetv(@dbo,"lat","lon","orid");
			($zone,$eing,$ning) = latlon_to_utm("wgs84",$olat,$olon);
			
			# convert one or the other, to compare xdist to olon
			
			# this is the conversion from Gerdom to UTM
			$xutm = ($xdist*1000)+350000-(143997-1236.5);
			($ylat,$xlon) = utm_to_latlon("wgs84",$zone,$xutm,$ning);
			$xlon = sprintf('%4.4f',$xlon);
			$ylat = sprintf('%4.4f',$ylat);
			$d = $xlon-$olon;
			
			# Your basic tree, check for match or cut search in half
			unless($d)   { last TREE; $nmin = $n;	# unlikely case  
			}
			elsif ($d<0) { $n2 = $n;
			}
			elsif ($d>0) { $n1 = $n;
			}
			else { $found = 1; print "Search error, rec $n\n";}
			
			# We're not going to match, so have to iterate to the 2 closest
			if (($n2-$n1)==1) {
				last TREE if $flag;	# run one more time...
				$flag = 1;		# then exit loop
			}
			
			# log the record if it's closer...
			if (abs($d)<$dmin) { 
				$dmin = abs($d);
				$nmin = $n;
			}
			
		}
		# exit TREE loop with $nmin the record number of closest shot, $dmin the distance from it
		# should do it in about 11 iterations, for ~ 1200 shots (rather than 1200 every time)
		
		# Get shot number, time and calculate absolute pick time.
		$dbo[3] = $nmin;
		($orid,$shottime,$slat,$slon) = dbgetv(@dbo,"orid","time","lat","lon");
		$ytime = $shottime + $ytime;
		
		#print "$count: Matched source at $xdist ($xlon) with shot #$orid ($slon) after $iter tries\n";
				
		# This writes to the database, comment out if just checking...
		#--------------------------------------------------------#
		# Add a new pick, get it's id, then associate it with the shot.
		@dba = @dbar;
		$dba[3] = dbaddv(@dbar,"time",$ytime,"iphase",'P',"sta",$sta);
		$arid = dbgetv(@dba,"arid");
		dbaddv(@dbas,"orid",$orid,"arid",$arid);
		#--------------------------------------------------------#
		$count++;
		
		
	}
	close(FILEIN);
	print "Entered $count picks for file: $pickfile\n";
	$totalpicks += $count;
	
}
close(PIPE);
dbclose(@db);
print "Total picks: $totalpicks\n";
