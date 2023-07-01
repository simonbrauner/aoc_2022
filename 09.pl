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

sub move_tail($head, $tail, $direction) {
    return if abs($head->{x} - $tail->{x}) <= 1
        && abs($head->{y} - $tail->{y}) <= 1;

    $tail->{$_} = $head->{$_} - $moves{$direction}->{$_} foreach ('x', 'y');
}

sub unique_positions(@movements) {
    my %positions;

    my $head = { x => 0, y => 0 };
    my $tail = { x => 0, y => 0 };

    foreach my $movement (@movements) {
        do {
            move_head($head, $movement->{direction});
            move_tail($head, $tail, $movement->{direction});

            $positions{$tail->{x} . ',' . $tail->{y}} = 1;
        } for (1..$movement->{steps});
    }

    return \%positions;
}

my @movements;

foreach my $line (<>) {
    $line =~ /(R|L|U|D) (\d+)/;

    push @movements, { direction => $1, steps => $2 };
}

say sum values unique_positions(@movements)->%*;
