#! /usr/bin/env perl
# Antelope database script
#
# db_cat2orig.pl catfile cat_db
# takes line catalog info and creates a CSS
# database "origin" table
# 
# Edit to match the format of the catalog
# (Right now it's ANSS)

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$infile = $ARGV[0];
$cat_db = $ARGV[1];



open(FILEIN, "<" , $infile)  or die "Can't open $infile: $!";

@db = dbopen("$cat_db", "r+");
@db = dblookup(@db, "" , "origin" , "", "" );

    while (<FILEIN>) {     # assigns each line in turn to $_
        $origin = $_;
	
	# Change to fit format of catalog file
	$origin =~ s/\// /g;
	$origin =~ s/:/ /g;
	($yr,$month,$day,$hr,$mn,$snd,$lat,$lon,$dep,$mag,$mtyp,$nst,$gap,$clo,$rms,$src) = split(' ',$origin);
	$time = "$yr-$month-$day $hr:$mn:$snd";
	
	# Adds events to origin table
	dbaddv(@db,"time",$time,"lat",$lat,"lon",$lon,"depth",$dep,"ml",$mag,"auth",$src);
	print "Added $time $mtyp $mag to $cat_db\n";
			 
    }

# OR?? #-- TEST --#
# print $out $_ if /foo/ while <$in> # not tested
