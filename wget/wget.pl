#!/usr/bin/perl

use 5.016;
use strict;
use warnings;

use Getopt::Long qw(:config no_ignore_case bundling);
use File::Path qw(make_path);
use AnyEvent::HTTP;
use Fcntl qw(F_GETFL F_SETFL O_NONBLOCK);
use Errno qw(EAGAIN EINTR EWOULDBLOCK);
use URI;
use Cwd;
use DDP;
$|++;

my $N = 10;
my $depth = 10;
my $recursive;
my $relative;
my $response;

GetOptions( 'N=n' => \$N,
		'L' => \$relative,
		'S' => \$response,
		'r' => \$recursive,
		'l=n' => \$depth) or die 'incorrect usage\n';

my $uri = shift;
my @queue = ($uri);

my $host = URI->new($uri)->host;
my %seen;
my $ACTIVE = 0;
my $cv = AE::cv();

$AnyEvent::HTTP::MAX_PER_HOST = my $LIMIT = 100;

my $path = cwd();
if(defined $recursive){
	make_path($host) or die $! unless ( -e $host );
	my $path = "$path/$host";
	chdir($path);
}

my $worker; $worker = sub {

	my $uri = shift @queue or return;
	$seen{ $uri } = undef;
	say "[$ACTIVE:$LIMIT] Start loading $uri (".(0+@queue).")";
	$ACTIVE++;

	timed_call (sub {

		http_request
			GET => $uri,
			timeout => 10,
			sub {

				my ($body,$hdr) = @_;		
				p $hdr if(defined $response);
				say "End loading $uri: $hdr->{Status}";
				$ACTIVE--;
				$seen{ $uri } = $hdr->{Status};

				if ($hdr->{Status} == 200) {
					new_file($uri, $body);

					my @href = $body =~ m/<a[^>]*href=["']?([^"'>]+)/sig;
					@href = grep (!/^http[s]?/, @href) if(defined $relative); 

					for my $href (@href) {
						my $new = URI->new_abs( $href, $hdr->{URL} );
						next if $new !~ /^https?:/;
						next if $new->host ne $host;
						next if exists $seen{ $new };
						push @queue, $new;
					}

				} else {
					say "Fail: @$hdr{qw(Status Reason)}";
				}

				while (@queue and $ACTIVE < $LIMIT and $ACTIVE <= $N and defined $recursive) {	                  
					$worker->();
				}
			}
	});
}; $worker->();


$cv->recv;
 

sub new_file {

	my ($uri, $body) = @_;
	$uri =~ /^http[s]?:\/\/[\.\w\d]*\/(.*)$/;

	my $dir = $1;
	my $fh;
	if(index($dir, '/', 0) >= 0){

		my $ind = rindex($dir, '/');
		my $name = substr($dir, $ind+1, length($dir));

		my @mass = $dir =~ /([^\/]+\/)/g;
		if($depth - 1 >= scalar @mass){
			$dir = join('', @mass[0..scalar @mass - 1]);
		} elsif (scalar @mass > $depth - 1) {
			return;
		} else {
			$dir = join('', @mass[0..$depth-1]);
		}
   
		make_path ($dir) or die $! unless ( -e $dir );
		open($fh, '>', "$dir/$name") or die $!;

	} else {

		$dir = '__index.html' if ($dir eq '');
		open($fh, '>', $dir) or die $!;
	}

	blocking($fh, 0);
	syswrite $fh, $body;
	close($fh);
}

sub timed_call {
	my $cb = pop;
	my $w;$w = AE::timer rand(0.1),0,sub {
		undef $w;
		$cb->(); 
	};
	return; 
}

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
