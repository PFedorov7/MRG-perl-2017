package Local::Reducer::Sum;

use 5.016;
use strict;
use warnings;
use utf8;
use Scalar::Util qw (looks_like_number);

use base 'Local::Reducer';

sub process_one {

    my ($self, $row_object) = @_;
    my $number =  $row_object->get($self->{field});
    $number // next;   
    if (looks_like_number($number)) { $self->{initial_value} += $number };

}

1;

