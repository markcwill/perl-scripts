#! /usr/bin/env perl

use File::Copy;
use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;


open(PIPE, "ls |");
while(<PIPE>) { print $_;
	chomp;
	$myfile = $_; # just throw it in, for now...
	if (m/Site_06\S+/)  {
		copy($myfile, "OBS06/$myfile") or die "Can't copy $myfile: $!";}
	elsif (m/Site_05\S+/) {
		copy($myfile, "OBS05/$myfile") or die "Can't copy $myfile: $!";}
	else { # leave it alone 
	}

}
