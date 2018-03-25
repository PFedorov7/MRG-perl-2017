#!/usr/bin/env perl

use 5.016;
use warnings;
use Time::Local 'timelocal';
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my @days = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
my @abbr = qw(January February March April May June July August September October November December);
$year = $year + 1900;
#учтен високосный год
if (!($year % 4)) {
        $days[1] = 29;
}
my $month_day = 1;      #переменная-счетчик дней месяца 
my $week_day = 0;       #переменная-счетчик дней недели
my $count = -1;
#реализовано отображение элементов соответсвующее cal в unix
#переносим $mday на позицию, соответсвующую его $wday
#условие $count == -1 необходимо для верного отображения первой недели первого месяца.
sub mystyle{
        my $count = shift;
        my $wday = shift;

        if($count == 5 || $count == -1 && $wday == 6){ printf('%*s', $wday - 1 + 13," ")}
        if($count == 4 || $count == -1 && $wday == 5){ printf('%*s', $wday - 1 + 11 ," ")}
        if($count == 3 || $count == -1 && $wday == 4){ printf('%*s', $wday - 1 + 9," ")}
        if($count == 2 || $count == -1 && $wday == 3){ printf('%*s', $wday - 1 + 7," ")}
        if($count == 1 || $count == -1 && $wday == 2){ printf('%*s', $wday - 1 + 5," ")}
        if($count == 0 || $count == -1 && $wday == 1){ printf('%*s', $wday - 1 + 3," ")}

}
sub cal{

        my $month = shift;
        print ("     $abbr[$month] $year \n");
        printf('%20s', "Su Mo Tu We Th Fr Sa");
        print("\n");

        while($month_day <= $days[$month]){

                my $time = timelocal(0, 0, 0, $month_day, $month, $year);
                my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);

                while($week_day <= 6){
                        mystyle($count, $wday);
                        $count = 7;

                                if ($week_day == $wday){ printf('%3s', "$mday ")}
                                if($wday == 6 && $week_day == 6){ print("\n")}

                                $week_day = $week_day + 1;
                        }

                $week_day = 0;
                $month_day = $month_day + 1;
        }
        print("\n");
}


if (@ARGV == 1) {
        # нам передали номер месяца. проверяем параметр и
        # печатаем календарь на этот месяц
        my ($month) = @ARGV;

        if($month > 12 || $month < 1){
        die("The month number must be in (1..12)\n");
        }

        $month = $month - 1;

        cal($month);
}
elsif (not @ARGV) {
    # печатаем календарь на текущий месяц               
        cal($mon);

}
else {
        print ("Wrong arguments\n");
}
