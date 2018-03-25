#!/usr/bin/perl

use 5.016;
use warnings;
use strict;
use IO::Socket;
use Getopt::Long;
use feature 'say';

sub dosocket{

    my ($addr, $port, $proto) = @_;
    my $socket = IO::Socket::INET->new(
        PeerAddr => $addr,
        PeerPort => $port,
        Proto    => $proto)
    or die "Can't connect to  $addr $/";
    return $socket;
}

my ($addr, $port) = @ARGV;
my @data = <STDIN>;

my $proto = getprotobyname('tcp');
my $udp;
my $socket;
GetOptions( "u" => \$udp) or die("Error");

if (defined $udp) {
    my $proto = getprotobyname('udp');
    $socket = dosocket($addr, $port, $proto);
} else {
    $socket = dosocket($addr, $port, $proto);
}

#программа-клиент устанавливает tcp соединение и передает данные из STDIN на сервер
send($socket , "@data" , 0);
$socket->close();