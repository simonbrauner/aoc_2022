#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum};

use Set::Scalar;


sub priority($item) {
    return ord($item) - ord('a') + 1 if $item =~ /[a-z]/;
    return ord($item) - ord('A') + 27 if $item =~ /[A-Z]/;
}

sub split_rucksack($rucksack) {
    my $length = length($rucksack);

    return [ (substr $rucksack, 0, $length / 2),
             (substr $rucksack, $length / 2, $length) ]
}

sub string_to_set($string) {
    Set::Scalar->new(split //, $string)
}

sub item_in_both($rucksack) {
    my ($first, $second) = map { string_to_set($_) } split_rucksack($rucksack)->@*;

    return $_ foreach $first->intersection($second)->elements;
}

sub item_in_three(@rucksacks) {
    my ($f, $s, $t) = map { string_to_set($_) } @rucksacks;

    return $_ foreach $f->intersection($s)->intersection($t)->elements;
}

sub sum_of_priorities_1(@rucksacks) {
    sum (map { priority(item_in_both($_)) } @rucksacks);
}

sub sum_of_priorities_2(@rucksacks) {
    my $sum = 0;

    for (my $i = 0; $i < @rucksacks; $i += 3) {
        $sum += priority(item_in_three(@rucksacks[$i..$i+2]));
    }

    return $sum;
}

my @rucksacks;

foreach my $line (<>) {
    chomp $line;

    push @rucksacks, $line;
}

say sum_of_priorities_1(@rucksacks);
say sum_of_priorities_2(@rucksacks);
