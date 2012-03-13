#! /usr/bin/env perl
#

#use lib "$ENV{ANTELOPE}/data/perl/";
#use Datascope;
#use Geo::Coordinates::UTM;

#-- Help
$help =  <<"EOF";
pass file, subtracts offset from first column for Gerdom model
EOF

if ($ARGV[0] =~ m/-h/) { $flag = print "$help"; }

MAIN: { last MAIN if $flag;

$infile = $ARGV[0];
$x_corr = 135; # up to 142ish

open(FILEIN, "<$infile")  or die "Can't open $infile: $!";
while (<FILEIN>) {
	chomp;    
    ($x,$z) = split(" ",$_);   
	$x -= $x_corr;
	printf "%4.4f %3.3f \n",$x, $z;
	}
close(FILEIN);
}
