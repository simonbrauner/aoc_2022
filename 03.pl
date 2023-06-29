#!/usr/bin/env perl

use v5.36;


sub create_rucksack($line) {
    my $length = length($line);

    return { first => (substr $line, 0, $length / 2),
             second => (substr $line, $length / 2, $length) }
}

my @rucksacks;

foreach my $line (<>) {
    chomp $line;

    push @rucksacks, create_rucksack($line);
}
