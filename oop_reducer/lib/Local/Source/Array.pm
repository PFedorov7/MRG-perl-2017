package Local::Source::Array;

use 5.016;
use warnings;
use strict;
use utf8;
use base "Local::Source";


sub new {

	my ($self, %args) = @_; 
	$self -> SUPER::new(array => $args{array});
}

1;
