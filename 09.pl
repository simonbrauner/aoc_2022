#!/usr/bin/env perl

use v5.36;


my %moves = (R => { x => 1, y => 0 },
             L => { x => -1, y => 0 },
             U => { x => 0, y => 1 },
             D => { x => 0, y => -1 });

sub move_head($head, $direction) {
    $head->{$_} += $moves{$direction}->{$_} foreach ('x', 'y');
}

sub unique_positions(@movements) {
    my %positions;

    my $head = { x => 0, y => 0 };
    my $tail = { x => 0, y => 0 };

    foreach my $movement (@movements) {
        do {
            move_head($head, $movement->{direction});
        } for (1..$movement->{steps});
    }

    say $head->{x};
    say $head->{y};
}

my @movements;

foreach my $line (<>) {
    $line =~ /(R|L|U|D) (\d+)/;

    push @movements, { direction => $1, steps => $2 };
}

unique_positions(@movements);
