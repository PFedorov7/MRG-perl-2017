#!/usr/bin/perl

use 5.016;
use warnings;
use strict;

use Getopt::Long qw(:config no_ignore_case bundling);
my ($after, $before, $context, $count, $ignore, $invert, $fixed, $line);
my $num = 0;
GetOptions ('A=n' => \$after,
			'B=n' => \$before,
			'C=n' => \$context, 
			'c' => \$count,
			'i' => \$ignore,
			'v' => \$invert,
			'F' => \$fixed, 
			'n' => \$line
 );

my ($pattern) = @ARGV;
my @input = <STDIN>;
chomp(@input);	

$pattern = quotemeta $pattern if (defined $fixed);
$pattern = fc ($pattern), map { $_ = fc ($_) } @input if (defined $ignore);
$invert //= 0;

for my $i (0..$#input) {
	if ($input[$i] =~ /($pattern)/ != $invert) {
		$num++;
		next if defined $count;
		if(defined $context) {
      		B ($i, $context, $line, @input);
      		printer($i); ;
      		A ($i, $context, $line, @input);
    	} else {

      		if (defined $before) {
      			B ($i, $before, $line, @input);
      			$after // printer($i);
      		} 
      		if (defined $after){
      			printer($i);
      			A ($i, $after, $line, @input);
      		} else {
      			printer($i);;
      		}

    	}
	}
}
print "$num\n" if (defined $count);

sub printer {
	my ($i) = shift;
	defined $line ? print "$i :   $input[$i]\n" : print "$input[$i]\n";
}

sub A {
  my ($local, $edge, @text) = @_;
  my $limit = $local + $edge;
  my $end = $limit < $#text ? $limit : $#text - 1;
  for my $i ($local + 1..$end) {
    printer($i); ;
  }
}

sub B {
  my ($local, $edge, @text) = @_;
  my $limit = $local - $edge;
  my $start = $limit > 0 ? $limit : 0;
  for my $i ($start..$local - 1) {
    printer($i); ;
  }
}