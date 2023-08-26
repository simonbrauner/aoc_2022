#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};

use List::Util qw{first};


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

sub lcm($a, $b) {
    first { $_ % $a == 0 && $_ % $b == 0 } (1..$a*$b);
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

sub accessible($valley, $x, $y, $new_x, $new_y) {
    return 1 if $x == $new_x == 0 && $y == $new_y == -1;

    return 0 <= $new_x < $valley->[0]->@* && 0 <= $new_y < $valley->@*
        && $valley->[$new_y][$new_x]->@* == 0;
}

sub add_edges($next_valley, $graph, $from, $to, $x, $y) {
    my $edges = [];

    for my $movement (values %movements, [0, 0]) {
        my $new_x = $x + $movement->[0];
        my $new_y = $y + $movement->[1];

        push $edges->@*, "$to,$new_x,$new_y"
            if accessible($next_valley, $x, $y, $new_x, $new_y);
    }

    unshift $edges->@*, 'goal'
        if $x == $next_valley->[0]->@*-1 && $y == $next_valley->@*-1;

    $graph->{"$from,$x,$y"} = $edges;
}

sub create_graph($valley) {
    my $graph = {};

    my $state_count = lcm(scalar $valley->@*, scalar $valley->[0]->@*);
    for my $layer (1..$state_count) {
        my $next_valley = next_valley($valley);

        my @part_of_arguments = ($next_valley, $graph, $layer - 1, $layer % $state_count);

        add_edges(@part_of_arguments, 0, -1);
        for my $y (0..$valley->@*-1) {
            for my $x (0..$valley->[0]->@*-1) {
                add_edges(@part_of_arguments, $x, $y);
            }
        }

        $valley = $next_valley;
    }

    return $graph;
}

sub shortest_path($graph, $start) {
    my @queue = ($start, 0);
    my %seen;

    while (@queue) {
        my ($current, $path) = map { shift @queue } (1..2);
        return $path if $current eq 'goal';

        foreach my $neighbor ($graph->{$current}->@*) {
            next if exists $seen{$neighbor};
            $seen{$neighbor} = undef;

            push @queue, $neighbor, $path + 1;
        }
    }
}

my $valley = [];

foreach my ($y, $row) (builtin::indexed <>) {
    chomp $row;

    foreach my ($x, $tile) (builtin::indexed split //, $row) {
        next if $x == 0 || $x == (length $row) - 1 || $y == 0;

        $valley->[$y - 1][$x - 1] = $tile eq '.' ? [] : [$tile];
    }
}
pop $valley->@*;

say shortest_path(create_graph($valley), '0,0,-1');
