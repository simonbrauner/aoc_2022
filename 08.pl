#!/usr/bin/env perl

use v5.36;


my @forest;

foreach my $line (<>) {
    chomp $line;

    my @tree_line = map { { height => $_, visible => 0 } } split //, $line;
    push @forest, \@tree_line;
}

say "@forest";
say $forest[0][0]{visible};
