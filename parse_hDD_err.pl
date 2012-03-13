#!/usr/bin/env perl

open(FILEIN, "<hypoDD.log");
open(FILEOUT,">hypo_err.log");
LOGGING: while (<FILEIN>) { 
		
		next LOGGING unless m/ITERATION\s+(\d+)|weighted (\w\w) rms/; 
		
		chomp;
		$number = $1;
				
		if (m/ITERATION/) {
			$it = $number;
			next LOGGING;
		}
		elsif (m/cc/) { 
			($label, $value) = split(/=/);
			@ccnums = split(/[\(\)%]/,$value);
			$cc = $ccnums[0];
			$ccp = $ccnums[1];
			if ($ccnums[0] =~ m/\.\d/) { $ccfin = $ctnums[0]; }
			next LOGGING;
		}
		elsif (m/ct/) {
			($label, $value) = split(/=/);
			@ctnums = split(/[\(\)%]/,$value);
			$ct = $ctnums[0];
			$ctp = $ctnums[1];
			if ($ctnums[0] =~ m/\.\d/) { $ctfin = $ctnums[0]; }
		}
		else { $it = "OOPS!!";
		}
		print FILEOUT "$it $cc $ct\n";
		#print FILEOUT "$ccp $ctp\n";
}
print "$ccfin $ctfin\n";		
close(FILEIN);
close(FILEOUT);
			
		
		
