#!/usr/bin/env perl

use v5.36;

use List::Util qw{min max};


sub is_subrange($min_first, $max_first, $min_second, $max_second) {
    ($min_first <= $min_second && $max_first >= $max_second)
        || ($min_second <= $min_first && $max_second >= $max_first)
}

sub overlaps($min_first, $max_first, $min_second, $max_second) {
    max ($min_first, $min_second) <= min ($max_first, $max_second);
}

my @pairs;

foreach my $line (<>) {
    chomp $line;

    my @pair = $line =~ /(\d+)-(\d+),(\d+)-(\d+)/;
    push @pairs, \@pair;
}

say scalar grep { is_subrange($_->@*) } @pairs;
say scalar grep { overlaps($_->@*) } @pairs;
