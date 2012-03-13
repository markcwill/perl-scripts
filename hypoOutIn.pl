#!/usr/bin/env perl

open(FILEIN, "<hypoDD.reloc");
#open(FILEOUT,">event.dat.auto");
LOGGING: while (<FILEIN>) { 
		
		chomp;
	   	($hid,$lat,$lon,$dep,$x,$y,$z,$dx,$dy,$dz,$yr,$mth,$day,$hr,$mn,$snd,$mag,$nccp,$nccs,$nctp,$ncts,$rcc,$rct,$cid) = split(" ",$_);
		printf ("%4d%02d%02d %2d%02d%04d $lat $lon $dep $mag 0.0 0.0 0.0 $hid\n" , $yr,$mth,$day,$hr,$mn,$snd*100);
}
#print "$ccfin $ctfin\n";		
close(FILEIN);
#close(FILEOUT);
			