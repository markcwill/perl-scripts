#!/usr/bin/env perl

open(FILEIN, "<$ARGV[0]");
$count = 0;
LOGGING: while (<FILEIN>) { 
		next LOGGING unless m/\d/;
		$count++
}
print "$count\n";		
close(FILEIN);