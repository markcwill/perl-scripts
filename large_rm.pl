#! /usr/bin/env perl

use File::Copy;

$regexp = $ARGV[0];
open(PIPE, "ls |");
while(<PIPE>) { print $_;
	chomp;
	$myfile = $_; # just throw it in, for now...
	if (m/\S+$regexp\S+/)  {
		unlink ($myfile) or die "Can't remove $myfile: $!";}

	else { # leave it alone 
	}

}
