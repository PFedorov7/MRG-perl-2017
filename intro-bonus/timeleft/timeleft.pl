#!/usr/bin/env perl

use 5.016;
use warnings;

use Time::Local 'timelocal';
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

my $leftHourSec = (60 - ($min + 1)) * 60 + (60 - $sec);
my $leftDaySec = (24 - ($hour + 1)) * 60 * 60 + $leftHourSec;
my $leftWeekSec = (8 - ($wday + 1)) * 24 * 60 * 60 + $leftDaySec;

print("Current time : $hour:$min:$sec\n\n");
print("Seconds to the end of the:\n");
print("hour: $leftHourSec sec\n");
print("day: $leftDaySec sec\n");
print("week: $leftWeekSec sec\n");



