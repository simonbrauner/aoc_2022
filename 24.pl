#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};


sub print_valley($valley) {
    for my $y (0..$valley->@*-1) {
        for my $x (0..$valley->[0]->@*-1) {
            print scalar (($valley->[$y][$x] // [])->@*);
        }
        say '';
    }
}

my $valley = [];

foreach my ($y, $row) (builtin::indexed <>) {
    chomp $row;

    foreach my ($x, $tile) (builtin::indexed split //, $row) {
        next if $x == 0 || $x == (length $row) - 1
            || $y == 0 || $tile eq '.';

        push $valley->[$y - 1][$x - 1]->@*, $tile;
    }
}
pop $valley->@*;

print_valley($valley);
