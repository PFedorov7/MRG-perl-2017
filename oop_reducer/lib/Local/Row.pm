package Local::Row;

use 5.016;
use warnings;
use strict;

sub new {

	my ($class, %str) = @_;
	bless $str{str}, $class;
}

sub get {

    my ($self, $name, $default) = @_;
    $self->{$name} // $default;
}

1;
