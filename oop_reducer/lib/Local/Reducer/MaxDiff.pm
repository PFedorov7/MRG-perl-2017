package Local::Reducer::MaxDiff;

use 5.016;
use strict;
use warnings;
use utf8;
use Scalar::Util qw (looks_like_number);

use base 'Local::Reducer';

sub process_one {
    
    my ($self, $row_object) = @_;

    my $top =  $row_object->get($self->{top});
    my $received =  $row_object->get($self->{bottom});

    $top // ($top = 0);
    $received // ($received = 0);
    
    if (looks_like_number($received) and looks_like_number($received)){
    	my $min = $top - $received;
    	$self->{initial_value} = $min if $min > $self->{initial_value};
    }

    
}

1;


