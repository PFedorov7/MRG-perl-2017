package Local::Row::JSON;

use 5.016;
use warnings;
use strict;
use utf8;
use JSON;
use base "Local::Row";

sub new {

    my ($class, %str) = @_;
    my $str;

    eval{
        $str = JSON->new->decode($str{str});
    };
  
    if (defined $str and ref($str) eq "HASH") {
    	$class -> SUPER::new(str => $str);
    } else {
    	return undef;
    }

}

1;
