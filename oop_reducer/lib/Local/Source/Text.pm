package Local::Source::Text;

use 5.016;
use warnings;
use strict;
use utf8;
use base "Local::Source";

sub new {

    my ($self, %args) = @_;
    
    $args{delimiter} // ( $args{delimiter} = '\n' );
    my @arr = split(/$args{delimiter}/, $args{text});
    $self -> SUPER::new(array => \@arr);
}

1;


