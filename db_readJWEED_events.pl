#! /usr/bin/env perl
# Antelope database script
#
# db_readJWEED_events.pl file.events cat_db
# takes JWEED *.events file and creates a CSS
# database "origin" table
# 
# Edit to match the format of the catalog
#  (this one's JWEED - comma delimited)

use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$infile = $ARGV[0];
$cat_db = $ARGV[1];

open(FILEIN, "<" , $infile)  or die "Can't open $infile: $!";

@db = dbopen("$cat_db", "r+");
@db = dblookup(@db, "" , "origin" , "", "" );

    while (<FILEIN>) {     # assigns each line in turn to $_
        $origin = $_;
	
	($catalog,$timeString,$lat,$lon,$depth,$xJunk,$yJunk,$mTyp1,$mag1,$mTyp2,$mag2) = split(',',$origin);
	$timeString =~ s/\//-/g;
	$src = $catalog;
	
	# Adds events to origin table
	dbaddv(@db,"time",$timeString,"lat",$lat,"lon",$lon,"depth",$depth,"ml",$mag1,"auth",$src);
	print "Added $time $mTyp1 $mag1 to $cat_db\n";
	
	}
	
close FILEIN;
dbclose(@db);
