package Local::Reducer;

use 5.016;
use Carp;
use Local::Reducer;
use Local::Source;
use Local::Row;

use strict;
use warnings;
use utf8;

our $VERSION = '1.00';

sub new {

    my ($class, %args) = @_;
    bless \%args, $class; 
}

sub reduced {

     my $self = shift;    
     return $self->{initial_value};       
 }

 sub reduce_all {

 	my $self = shift;
    $self->action();
    return $self->{initial_value};
 }

 sub reduce_n {

     my ($self, $n) = @_;
     $self->action($n); 
     return $self->{initial_value}; 
 }

 sub action {

 	my ($self, $n) = @_;

    while (my $item = $self->{source}->next) {

        my $row_object = $self->{row_class}->new(str => $item);
        $row_object // next;  
        $self -> process_one($row_object);    
    } continue {
        if(defined $n){
            $n--; 
            last unless $n;
        }
    }
 }

 sub process_one{
    confess  "Method 'process_one' should be defined in subclass";
 };
 
1;
