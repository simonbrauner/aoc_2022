#!/usr/bin/env perl

use v5.36;


sub manhattan_distance(@coords) {
    my $distance = 0;

    for (my $dim = 0; $dim < @coords / 2; $dim++) {
        $distance += abs($coords[$dim] - $coords[@coords / 2 + $dim]);
    }

    return $distance;
}

sub surface_area(@cubes) {
    my $area = 6 * @cubes;

    foreach my $i (0..@cubes-1) {
        foreach my $j ($i..@cubes-1) {
            next if $i == $j;

            $area -= 2 if manhattan_distance($cubes[$i]->@*, $cubes[$j]->@*) == 1;
        }
    }

    return $area;
}

my @cubes;

foreach my $line (<>) {
    chomp $line;

    my @cube = split ',', $line;
    push @cubes, \@cube;
}

say surface_area(@cubes);
