#!/usr/bin/perl -w
use strict;


my ($infile,$annofile,$outfile)=@ARGV;

#annotation
#only missense is needed

my %nonsyn;

open(IN,$annofile) || die $!;
while(<IN>) {
	tr/\r\n//d;
	my @array=split/\t/;
	
	if($array[10] eq "NON_SYNONYMOUS")  {
		$nonsyn{$array[0]}++;
	}
}
close IN;


#read calling
open(IN,$infile) || die $!;
open(OUT,">$outfile") || die $!;

my %sample2mut;

while(<IN>) {
	tr/\r\n//d;
	my @array=split/\t/;
	
	if(defined $nonsyn{$array[2]}) {
		$sample2mut{$array[1]}++;
	}
}
close IN;

print OUT "Sample\tNonsynMut\n";
foreach my $sample (sort keys %sample2mut) {
	print OUT $sample,"\t",$sample2mut{$sample},"\n";
}
close OUT;
