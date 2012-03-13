#! /usr/bin/env perl

$count = 0;
open LSIN ,'\ls *.kea |' or die "Can't open pipe $!";

PIPE: while(<LSIN>) {
	chomp;
	$filename = $_;
	open KEAFILE ,"<$filename" or die "Can't open infile $!";
	open OUTFILE ,">${filename}.shottime" or die "Can't open outfile $!";
	KLINE: while(<KEAFILE>) { next KLINE if m/RecNum/;
		($shotnum, $ddmmyyyy, $hhmmss, @andtherest) = split(/,/,$_);
		if ($ddmmyyyy =~ m/(\d{2})(\d{2})(\d{4})/) {
			$day = $1;
			$month = $2;
			$year = $3;
		}
		if ($hhmmss =~ m/(\d{2})(\d{2})(\d{2})/) {
			$hour = $1;
			$minute = $2;
			$second = $3;
		}
		@lats = split(/(\s+|N|S)/,$andtherest[-2]);
		@lons = split(/(\s+|W|E)/,$andtherest[-1]);
		
		$lat  = $lats[0]+($lats[2]/60.0);
		$lat *= -1 if $lats[3] =~ m/S/;
		$lat  = sprintf('%2.8f',$lat);
	
		$lon  = $lons[0]+($lons[2]/60.0);
		$lon *= -1 if $lons[3] =~ m/W/; 
		$lon  = sprintf('%3.8f',$lon);
		print OUTFILE "$shotnum $year $month $day $hour $minute $second $lat $lon\n";
	}
$count++;	
close KEAFILE;
close OUTILFE;
}
close LSIN;
print "Done, read $count kea files\n";
		
