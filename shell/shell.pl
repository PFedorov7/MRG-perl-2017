#!/usr/bin/perl 

use strict;
use warnings;
use 5.016;
use Cwd;
use POSIX qw(:sys_wait_h);
use IPC::Open3;
$|=1;

sub is_interactive {
    return -t STDIN && -t STDOUT;
}

sub cd {
    my $path = shift; 
    if(defined $path) { chdir($path) };
}

sub pwd {
    say cwd;
}

sub echo {
    my $args = shift; 
    say join(" ", @$args[1..@$args-1]);    
}

sub killtest {
    my $args = shift;
    if($$args[1] and $$args[2]) { kill("$$args[1]", "$$args[2]") }
    else { print 'wrong syntax'};
}

sub ps{
    
    opendir(my $dh, '/proc/') or die $!;
    my $fname = 'cmdline';
    while(my $proc = readdir $dh){
        
        if($proc =~ /\d/){

            if(-z "/proc/$proc/$fname" and -e "/proc/$proc/$fname"){

                open(my $fh, '<', "/proc/$proc/$fname") or die $!;

                while(<$fh>){
                    say "$proc : $_";
                }

                close($fh);
            }
        }      
    }
    closedir($dh);
}



my $do = 1;
my $start_pid = 1;

my ($r, $w);
pipe($r, $w);

while( is_interactive() && $do ){

    my $line = <>;
    my @lines = split('\s+', $line);

    if ($lines[0] eq 'cd') { cd ($lines[1]); next; }
    if ($lines[0] eq 'pwd') {pwd (); next; }
    if($lines[0] eq 'echo') {echo (\@lines); next; }
    if($lines[0] eq 'ps') {ps (); next; }
    if($lines[0] eq 'kill') {killtest (\@lines); next}  


    #проверка на наличие в команде |
    my $ind = 0;
    my @ind; 
    my @dirs;
    
    map { 
        if($_ eq '|') { 
            push (@ind, $ind); 
        } 
        $ind++;
    } @lines;

    #pipe
    my $counter = 1;
    my $now = 0;
    my @res;
    
    if(scalar @ind){
        foreach my $arg(@ind){

            #выполняем команду слева от конвейера
            my ($wtr1, $rdr1);
            my $command = join(" ", @lines[$now..$arg-1]);
            my $pid1 = open3($wtr1, $rdr1, undef, $command);
            if ($counter > 1) {
                    for my $res (@res) {
                        print {$wtr1} $res;
                }
                close($wtr1);
            }
            my @dirs = <$rdr1>;

            #выполняем команду справа, до следующего конвейера, если он есть
            my ($wtr2, $rdr2);
            my $pattern;
            #если дальше нет конвейера, выставляем правую границу как последний элемент массива
            unless($ind[$counter]) { $pattern = scalar @lines - 1} 
            else { $pattern = $ind[$counter] - 1 };
            my $command2 = join(" ", @lines[$arg+1..$pattern]);
            my $pid2 = open3($wtr2, $rdr2, undef, $command2);
            for my $dir (@dirs) {
                print {$wtr2} $dir;
            }
            close($wtr2);

            @res = <$rdr2>;

        } continue {
            $now = $arg + 1;
            $counter++;
        }

        print @res;
    } else {
        #Выполнение одиночной команды
        if(my $pid = fork()){
            waitpid($pid, 0);
        } else {
            die "Cannot fork $!" unless defined $pid;
            my $command = join(" ", @lines[0..scalar @lines - 1]);
            exec("$command");
        }
    }
    
    $do = 0 if $line eq "bye$/";
}

1;
