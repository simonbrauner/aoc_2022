#!/usr/bin/env perl

use v5.36;


my @rows;

foreach my $line (<>) {
    chomp $line;

    my @row = split //, $line;
    push @rows, \@row;
}
