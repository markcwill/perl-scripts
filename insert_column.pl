#! /usr/bin/env perl
#
#     -by Mark

$infile1 = $ARGV[0];
$infile2 = $ARGV[1];
$colNum = $ARGV[3];

open(FILEINA, "<$infile1") or die "Can't open $infile1: $!";
open(FILEINB, "<$infile2") or die "Can't open $infile2: $!";

MYLINE: while(<FILEINA>) {
	chomp;
	@origFile = split(/ /,$_);
	$newCol = <FILEINB>;
	chomp($newCol);
	for ($col=0; $col<@origFile;$col++) {
		if ($col==$colNum-1) {
			print "$newCol ";
		}
		else {	print "$origFile[$col] ";}
	}
	print "\n";

} 


