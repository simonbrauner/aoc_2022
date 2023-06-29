#!/usr/bin/env perl

use v5.36;


sub is_subrange($min_first, $max_first, $min_second, $max_second) {
    ($min_first <= $min_second && $max_first >= $max_second)
        || ($min_second <= $min_first && $max_second >= $max_first)
}

sub count_subranges(@pairs) {
    scalar grep { is_subrange($_->@*) } @pairs;
}

my @pairs;

foreach my $line (<>) {
    chomp $line;

    my @pair = $line =~ /(\d+)-(\d+),(\d+)-(\d+)/;
    push @pairs, \@pair;
}

say count_subranges(@pairs);
