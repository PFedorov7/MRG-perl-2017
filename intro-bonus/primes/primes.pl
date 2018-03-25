#!/usr/bin/env perl

use 5.016;
use warnings;

my ($N) = @ARGV;

if(!$N){
	print ("no arguments\n");
	exit;
}

if (@ARGV > 1) {
        print ("Bad arguments\n");
        exit;
}  

my @primes;
push(@primes,2);

unless($N =~ m/^\d*$/ ){ 
	print("Enter only natural numbers\n");
	exit;
}

exit if($N == 1);
if($N == 2) {
	print("2"); 
	exit;
}

my $i;
my $counter = 1; 

for ($i = 3; $i <= $N; $i++){

	for (my $j = 2; $j <= $i; $j++){
		
		if($i == $j){
			$primes[$counter] = $i;
			$counter++;
			last;
		}		
		last if($i % $j == 0);
	}
}

for ($i = 0; $i <= ($counter-1); $i++){
	print("$primes[$i] \n")
}
