#!/usr/bin/env perl

use 5.016;
use warnings;

my ($haystack, $needle) = @ARGV;

if (@ARGV == 2){

	if ($haystack =~/$needle/){

	my $i = index($haystack, $needle, 0);
	print("$i\n");

	$haystack = substr($haystack, $i);
	print("$haystack\n")

	} else {
	warn "substring not found";
	exit;
	}

} else {
	print ("Invalid number of arguments\n");
}
