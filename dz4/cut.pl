#!/usr/bin/perl

use 5.016;
use strict;
use warnings;
use feature 'say';
use Getopt::Long qw(:config no_ignore_case bundling);
use Data::Dumper;

my @fields;
my $delimiter = '\t';
my $separated;


GetOptions('f=s' => \@fields,
           "d=s" => \$delimiter,
           "s" => \$separated)
or die("Error in command line arguments\n");

@fields = split(/,/,join(',', @fields));

my %hash;
while (<STDIN>){
    chomp;
    if(defined $separated) { next unless($_ =~ /$delimiter/)}; 
    push (my @array, split(/$delimiter/, $_)); 
    $hash{$.} = [@array];

}

foreach my $key (sort {$a <=> $b} keys %hash){
	my @array = @{$hash{$key}};
	map { if(scalar @array > $_ - 1) {print $array[$_-1]."\t"} } @fields;
	print "\n";
}