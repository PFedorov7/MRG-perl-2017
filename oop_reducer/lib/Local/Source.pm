package Local::Source;

use 5.016;
use warnings;
use strict;
use utf8;

sub new {

	my ($class, %args) = @_;
    $args{iterator} = 0;
    bless \%args, $class;
}

sub next {

    my $self = shift;
    my $element;
    
    if ($self->{iterator} < @{$self->{array}}) {
        $element = $self->{array}->[$self->{iterator}];
        $self->{iterator}++;
    }  
    return $element;    
}


1;
