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

unless($N =~ m/^\d*$/ ){ 
	print("Enter only natural numbers\n");
	exit;
}

print fib($N), "\n";

sub fib{

	my $c = shift;
	return $c < 2? $c: fib($c-1)+fib($c-2);
}
