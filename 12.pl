#!/usr/bin/env perl

use v5.36;


my $movements = [[0, -1], [0, 1], [-1, 0], [1, 0]];

sub find_letter($letter, @rows) {
    for my $y (0..@rows-1) {
        for my $x (0..$rows[0]->@*-1) {
            if ($rows[$y]->[$x] eq $letter) {
                return "$x:$y";
            }
        }
    }
}

sub height($letter) {
    $letter = 'a' if $letter eq 'S';
    $letter = 'z' if $letter eq 'E';

    return ord $letter;
}

sub unvisited_neighbors($position, $rows, $visited) {
    my @neighbors;

    my ($x, $y) = split ':', $position;
    foreach my $movement ($movements->@*) {
        my ($dx, $dy) = $movement->@*;
        my ($nx, $ny) = ($x + $dx, $y + $dy);
        my $new_position = "$nx:$ny";

        if ((0 <= $nx < $rows->[0]->@*)
                && (0 <= $ny < $rows->@*)
                && !exists $visited->{$new_position}
                && height($rows->[$y][$x]) - 1 <= height($rows->[$ny][$nx])) {
            $visited->{$new_position} = undef;
            push @neighbors, $new_position;
        }
    }

    return @neighbors;
}

sub is_goal($position, $goal, @rows) {
    my ($x, $y) = split ':', $position;
    return $rows[$y]->[$x] =~ $goal;
}

sub shortest_path($goal, @rows) {
    my $end = find_letter('E', @rows);

    my @queue = ([$end, 0]);
    my %visited = ($end => undef);

    while (my $current = shift @queue) {
        my ($position, $distance) = $current->@*;

        push @queue, [$_, $distance + 1]
            foreach unvisited_neighbors($position, \@rows, \%visited);

        return $distance if is_goal($position, $goal, @rows);
    }
}

my @rows;

foreach my $line (<>) {
    chomp $line;

    my @row = split //, $line;
    push @rows, \@row;
}

say shortest_path(qr{S}, @rows);
say shortest_path(qr{S|a}, @rows);
