#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};

use List::Util qw{min max};


my %directions = (N => [0, 1], S => [0, -1], W => [-1, 0], E => [1, 0], 0 => [0, 0]);

sub turn($elves) {
}

sub rectangle_side($elves, $regex) {
    my @coords =  map { $_ =~ $regex; $1 } keys $elves->%*;
    return max(@coords) - min(@coords) + 1;
}

sub empty_ground_tiles($elves) {
    turn($elves) for (1..10);

    return rectangle_side($elves, qr{(.*),}) * rectangle_side($elves, qr{,(.*)})
        - keys $elves->%*;
}

my $elves = {};

foreach my ($y, $row) (builtin::indexed <>) {
    chomp $row;

    foreach my ($x, $tile) (builtin::indexed split //, $row) {
        $elves->{"$x,$y"} = undef
            if $tile eq '#';
    }
}

say empty_ground_tiles($elves);
