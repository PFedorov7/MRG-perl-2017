package Local::Row::Simple;

use 5.016;
use warnings;
use strict;
use utf8;
use base "Local::Row";


sub new{

    my ($class, %str) = @_;

    if($str{str} =~ /^([\w]+:[\w]+(,[\w]+:[\w]+)*)$/) {
        %str = split /[\:\,]/, $str{str};
    } elsif ($str{str} eq "" ){
        %str = ();
    } else {
        return undef;
    }

    $class -> SUPER::new(str => \%str);
}

1;
