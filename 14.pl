#!/usr/bin/env perl

use v5.36;

use List::Util qw{min max};


sub add_air($map) {
    my @x_vals = map { (split ',', $_)[0] } keys $map->%*;
    my @y_vals = map { (split ',', $_)[1] } keys $map->%*;

    for my $x ((min @x_vals)..(max @x_vals)) {
        for my $y ((min @y_vals)..(max @y_vals)) {
            $map->{"$x,$y"} //= '.';
        }
    }
}

sub create_map(@rocks) {
    my %map = ('500,0' => '+');

    foreach my $rock (@rocks) {
        my ($x, $y) = split ',', $rock->[0];

        foreach my $edge ($rock->@*) {
            my ($new_x, $new_y) = split ',', $edge;

            do {
                $x += $x < $new_x ? 1 : -1 if $x != $new_x;
                $y += $y < $new_y ? 1 : -1 if $y != $new_y;

                $map{"$x,$y"} = '#';
            } while $x != $new_x || $y != $new_y;
        }
    }

    add_air(\%map);

    return %map;
}

my @rocks;

foreach my $line (<>) {
    chomp $line;

    my @rock = split ' -> ', $line;
    push @rocks, \@rock;
}

my %map = create_map(@rocks);
