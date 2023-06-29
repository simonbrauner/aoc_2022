#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum};


sub priority($item) {
    return ord($item) - ord('a') + 1 if $item =~ /[a-z]/;
    return ord($item) - ord('A') + 27 if $item =~ /[A-Z]/;
}

sub item_in_both($rucksack) {
    foreach my $first_part_item (split //, $rucksack->{first}) {
        foreach my $second_part_item (split //, $rucksack->{second}) {
            return $first_part_item if $first_part_item eq $second_part_item;
        }
    }
}

sub create_rucksack($line) {
    my $length = length($line);

    return { first => (substr $line, 0, $length / 2),
             second => (substr $line, $length / 2, $length) }
}

sub sum_of_priorities(@rucksacks) {
    sum (map { priority(item_in_both($_)) } @rucksacks);
}

my @rucksacks;

foreach my $line (<>) {
    chomp $line;

    push @rucksacks, create_rucksack($line);
}

say sum_of_priorities(@rucksacks);
