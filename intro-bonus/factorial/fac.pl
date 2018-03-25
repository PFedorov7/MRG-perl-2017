#!/usr/bin/env perl

use 5.016;
use warnings;
my ($N) = @ARGV;

if(@ARGV == 0|| $N =~ /^\s+$/){

        die ("No arguments\n");
}
if (@ARGV > 1) {
        die ("Bad arguments\n");

}

#Можно вводить число в строке с пробелами
unless($N =~ m/^\s*\d*\s*$/ ){
        die("Enter only natural numbers\n");

}

#добавлен 0!
if($N == 0){
        print("1\n");
        exit;
}

$N = fac($N);
print("$N\n");
sub fac{

        my $c = shift;

        if ($c == 1){
                return 1;
        }

        return $c = $c * fac($c - 1);
}
