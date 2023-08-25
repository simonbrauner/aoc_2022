#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};


my %movements = ('<' => [-1, 0], '>' => [1, 0],
                 '^' => [0, -1], 'v' => [0, 1]);

sub print_valley($valley) {
    for my $y (0..$valley->@*-1) {
        for my $x (0..$valley->[0]->@*-1) {
            print scalar $valley->[$y][$x]->@*;
        }
        say '';
    }
}

sub next_valley($valley) {
    my $next_valley = [];

    for my $y (0..$valley->@*-1) {
        for my $x (0..$valley->[0]->@*-1) {
            $next_valley->[$y][$x] //= [];

            foreach my $blizzard ($valley->[$y][$x]->@*) {
                my $movement = $movements{$blizzard};
                my $new_x = ($x + $movement->[0]) % $valley->[0]->@*;
                my $new_y = ($y + $movement->[1]) % $valley->@*;
                push $next_valley->[$new_y][$new_x]->@*, $blizzard;
            }
        }
    }

    return $next_valley;
}

my $valley = [];

foreach my ($y, $row) (builtin::indexed <>) {
    chomp $row;

    foreach my ($x, $tile) (builtin::indexed split //, $row) {
        next if $x == 0 || $x == (length $row) - 1 || $y == 0;

        if ($tile eq '.') {
            $valley->[$y - 1][$x - 1] = [];
        } else {
            push $valley->[$y - 1][$x - 1]->@*, $tile;
        }
    }
}
pop $valley->@*;

print_valley($valley);
