#!/usr/bin/env perl

use 5.016;
use warnings;

my ($a,$b,$c) = @ARGV;

if (@ARGV == 0 || @ARGV > 3) {
	die ("Bad arguments\n");
} elsif ($a == 0) {
	die ("Not a quadratic equation\n");
}

	if (not defined $c) {$c = 0}
	if (not defined $b) {$b = 0}

my $d = $b ** 2 - 4 * $a * $c;

if($d < 0) {
	print ("No solutions\n");
	exit;
} else {
	my $X1 = (- $b + $d ** (1 / 2)) / 2 * $a;
	my $X2 = (- $b - $d ** (1 / 2)) / 2 * $a;
	print ("$X1, $X2\n");
} 
