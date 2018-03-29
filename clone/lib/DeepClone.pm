package DeepClone;

use 5.016;
use warnings;
use strict;
 
 sub clone {
 
 	my $orig = shift;
 	my $cloned;
 
 	if (ref($orig) eq ''){
 		$cloned = $orig;
 	} elsif (ref($orig) eq 'HASH') {
 		$cloned = {};
 		while (my($key, $value) = each(%$orig)) {
 			$cloned -> {$key} = $value;
 		}
 	} elsif (ref($orig) eq 'ARRAY') {
 		$cloned = [];
 		@$cloned = map {$_} @$orig;
 	}
 
 	my $unsup = 0;
 	do_check($cloned, \$unsup) ? undef : $cloned;
 }
 
 sub do_check {
 
 	my ($cloned, $unsup) = @_;
 
 	if (ref($cloned) eq ''){
 	} elsif (ref($cloned) eq 'HASH') {
 		while (my($key, $value) = each(%$cloned)) {
 			do_check($value, $unsup);
 		} 
 	} elsif (ref($cloned) eq 'ARRAY') {
 		map {do_check($_, $unsup)} @$cloned;
 	} else {
 		$$unsup++;
 	}
 	return $$unsup;
 }
 
 1;

1;