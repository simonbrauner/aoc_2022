#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};


my @elves;

foreach my ($y, $row) (builtin::indexed <>) {
    chomp $row;

    foreach my ($x, $tile) (builtin::indexed split //, $row) {
        push @elves, { x => $x, y => $y }
            if $tile eq '#';
    }
}

say foreach @elves;
