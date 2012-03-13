#! /usr/bin/env perl
# - by Mark
# 
# Thsi is an example of how to manipulate pf files
# using the perl implementation of the pf functions
#
# Specific values can be read from the pf file
# and written to the pf ojbject ("foo")
#
# You can also read (and write) values straight from the 
# hash/array structure, but it's probably not worth it, and
# it's more confusing... EVERYTHING (tables, arrays) is 
# returned as a reference, so you have to de-reference to access...
#
# Similarly, you have to pass a reference to 'pfput' to add/change
# an array or table, single values are just treated as scalars...


use lib "$ENV{ANTELOPE}/data/perl/";
use Datascope;

$pffile = $ARGV[0];

#@myarray = (1,2,3,4,5);
#$mine = \@myarray;
$mine = [1,2,3,4,5];
$pf_value = "confidence_level";

# get the whole pf file, by specifying no key...
$pfhash = pfget($pffile,"");

# create a new perl pf object, and put all of the values from the pf file in it...
$foo = pfnew("newpf");
foreach $key (keys %$pfhash) { 
	pfput($key,$$pfhash{$key},$foo);
}

print "$pf_value is: $$pfhash{$pf_value} \n";

# can do useful things, like generate your own arrival tables
# from a db in a loop, and run command line locations with
# each new file...

# here I'm just pulling it from the file... can generate your own
$arrival_table = pfget($pffile,"arrival_table");

pfput("arrival_table",$arrival_table,$foo);
pfput("my_table",$mine,$foo);
pfwrite("newdbloc.pf", $foo);


