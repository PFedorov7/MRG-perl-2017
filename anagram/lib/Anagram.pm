package Anagram;

use 5.016;
use warnings;
use utf8;
use open qw(:std :utf8);
use Encode qw(decode_utf8);
BEGIN{ @ARGV = map decode_utf8($_, 1),@ARGV; }

sub anagram {
	my $words_list = shift;
	my @words_list = @{$words_list};
	my %result;
	my %hash;
	my @sorted_keys;
	my $low_ind = 0;

	#Перевод входных строк в нижний регистр.
	my @lowercase = map { lc($_) } @words_list;

	#hash{входное слово в нижнем регистре} = [отсортированное по буквам слово, индекс слова]	
	foreach my $arg(@lowercase){
                my $arg1 = join '', sort split //, $arg;
		$hash{$arg} = [$arg1, $low_ind];
		$low_ind++;		
	}
 
	for my $key (sort { ${$hash{$a}}[0] cmp ${$hash{$b}}[0] } keys %hash) {
			push(@sorted_keys, $key);
	}

	my $ind = 1;
	my $ref = [];

	#Поиск анаграмм. Линейный алгоритм.
	#Время выполнения ~30sec.
	foreach my $arg(@sorted_keys){
		
		#Последний элемент уже учавствовал в сравнении. Выход из цикла.	
		last if $sorted_keys[-1] eq $arg;
		
		#Т.к хэш отсортирован по возрастанию значений, анаграммы находятся рядом.
		if (${$hash{$arg}}[0] eq ${$hash{$sorted_keys[$ind]}}[0]) {
                    push @{$ref}, $arg;

		} else {
			push(@{$ref}, $arg);

			#Для последнего элемента.
			if($ind == $#sorted_keys){
				push(@{$ref}, ${$hash{$sorted_keys[$ind]}}[0]);
			}
		
			my @index_array;

			#Корректировка вывода, в соответствии с ТЗ. 
			if (scalar @{$ref} > 1) {
				foreach my $arg1(@{$ref}){			
					push(@index_array,  ${$hash{$arg1}}[1]);
				}

				@index_array = sort {$a <=> $b} @index_array;#Поиск первого встретившегося слова множества.
				@{$ref} = sort @{$ref};#Сортировка анаграмм.
	
				$result{$lowercase[$index_array[0]]} = $ref;
			}

			#Множества из одного элемента удаляются.
			#if (scalar @{$ref} == 1){delete $result{$lowercase[$index_array[0]]}}
			$ref = [];
		}

		$ind++;
	}

	return \%result;
}

1;
