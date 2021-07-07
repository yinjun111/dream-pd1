#!/usr/bin/perl -w
use strict;

my ($infile,$outfile)=@ARGV;

open(IN,$infile) || die $!;
open(OUT,">$outfile") || die $!;

while(<IN>) {
	tr/\r\n//d;
	
	if($_=~/^Sample/) {
		print OUT $_,"\tAgeGroup\n";
	}
	else {
		my @array=split/\t/;
		unless($array[6] eq "NA") {
			print OUT $_,"\t",int($array[6]/10),"\n";
		}
		else {
			print OUT $_,"\tNA\n";
		}
	}
}

close IN;
close OUT;
	
	
