#!/usr/bin/perl

use 5.016;
use warnings;
use strict;

use AnyEvent::IO;
use Fcntl qw(F_GETFL F_SETFL O_NONBLOCK);
use Errno qw(EAGAIN EINTR EWOULDBLOCK);
use Socket ':all';
$|=1;

my $host = shift;
my $port = shift;

my $cv = AE::cv();

blocking(\*STDIN, 0);
blocking(\*STDOUT, 0);

socket my $s, AF_INET, SOCK_STREAM, IPPROTO_TCP;
blocking($s, 0);
my $addr = gethostbyname $host;
my $sa = sockaddr_in($port, $addr);
connect($s, $sa);

my ($r,$w, $guard);

$guard = AE::io $s, 0, sub {
	my $r = sysread($s, my $buf, 2048);
	syswrite STDOUT, $buf;
};

$r = AE::io \*STDIN, 0, sub {
	my $read = sysread(STDIN, my $buf, 2048);
	$w = AE::io $s, 1, sub {
		syswrite $s, $buf;
		undef $w;
	};
};

$cv->recv;

sub blocking {
	my ($handle, $blocking) = @_;
	die "Can't fcntl(F_GETFL)" unless my $flags =
				fcntl ($handle, F_GETFL, 0);
	my $current = ($flags & O_NONBLOCK) == 0;
	if(defined $blocking){
		$flags &= ~O_NONBLOCK if $blocking;
		$flags |= O_NONBLOCK unless $blocking;
		die "Can't fcntl(F_SETFL)" unless fcntl($handle, F_SETFL, $flags)
	}
	return $current;
}