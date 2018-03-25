#!/usr/bin/env perl

use 5.016;
use warnings;


use Math::Complex;

my ($a,$b,$c) = @ARGV;

if (@ARGV == 0 || @ARGV > 3) {
        print ("Bad arguments\n");
        exit;
} elsif ($a == 0) {
        print ("Not a quadratic equation\n");
        exit;
}

        if (not defined $c) {$c = 0}
        if (not defined $b) {$b = 0}

my $d = $b ** 2 - 4 * $a * $c;

if($d < 0) {

        $d = -$d;
		$d = $d ** (1 / 2);
		
		my $X1 = Math::Complex->new(- $b/(2 * $a),$d / (2 * $a));
		my $X2 = Math::Complex->new(- $b/(2 * $a),-$d / (2 * $a));
		
        print ("$X1, $X2\n");
        
} else {
        my $X1 = (- $b + $d ** (1 / 2)) / 2 * $a;
        my $X2 = (- $b - $d ** (1 / 2)) / 2 * $a;      
	print ("$X1, $X2\n");
}
   
