#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum};


my %moves = (R => { x => 1, y => 0 },
             L => { x => -1, y => 0 },
             U => { x => 0, y => 1 },
             D => { x => 0, y => -1 });

sub move_head($head, $direction) {
    $head->{$_} += $moves{$direction}->{$_} foreach ('x', 'y');
}

sub tail_direction($head, $tail) {
    my ($dx, $dy) = map { $head->{$_} - $tail->{$_} } ('x', 'y');

    return 'R' if $dx == 2;
    return 'L' if $dx == -2;
    return 'U' if $dy == 2;
    return 'D' if $dy == -2;
}

sub move_tail($head, $tail) {
    my $direction = tail_direction($head, $tail);
    return if !$direction;

    $tail->{$_} = $head->{$_} - $moves{$direction}->{$_} foreach ('x', 'y');
}

sub unique_positions($knot_count, @movements) {
    my %tail_positions;
    my @knots = map { { x => 0, y => 0 } } (1..$knot_count);
    my $tail = $knots[$knot_count - 1];

    foreach my $movement (@movements) {
        do {
            move_head($knots[0], $movement->{direction});

            for (my $index = 1; $index < $knot_count; $index++) {
                move_tail($knots[$index-1], $knots[$index]);
            }

            $tail_positions{$tail->{x} . ',' . $tail->{y}} = 1;
        } for (1..$movement->{steps});
    }

    return \%tail_positions;
}

my @movements;

foreach my $line (<>) {
    $line =~ /(R|L|U|D) (\d+)/;

    push @movements, { direction => $1, steps => $2 };
}

say sum values unique_positions(2, @movements)->%*;
say sum values unique_positions(10, @movements)->%*;
