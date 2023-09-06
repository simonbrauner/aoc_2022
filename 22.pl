#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};

use Scalar::Util qw{looks_like_number};
use List::Util qw{min max};


my $turns = { R => { qw{R D D L L U U R} },
              L => { qw{R U U L L D D R} } };

my $moves = { R => [1, 0], D => [0, 1], L => [-1, 0], U => [0, -1] };

my $facing_number = { R => 0, D => 1, L => 2, U => 3 };

sub wrap_2d($coords, $direction) {
    my ($x, $y) = $coords->@*;

    if ($direction eq 'R') {
        $coords->[0] = $y <= 100 ? 51 : 1;
    } elsif ($direction eq 'L') {
        $coords->[0] = do {
            if ($y <= 50) { 150 } elsif ($y <= 150) { 100 } else { 50 }
        }
    } elsif ($direction eq 'D') {
        $coords->[1] = $x <= 50 ? 101 : 1;
    } else {
        $coords->[1] = do {
            if ($x <= 50) { 200 } elsif ($x <= 100) { 150 } else { 50 }
        }
    }
}

sub move($x_ref, $y_ref, $direction, $map, $wrap) {
    my $coords = [ map { $_->$* } ($x_ref, $y_ref) ];
    $coords->[$_] += $moves->{$direction}->[$_] for (0..1);

    $wrap->($coords, $direction)
        if !exists $map->{$coords->[0] . ',' . $coords->[1]};

    if ($map->{$coords->[0] . ',' . $coords->[1]} ne '#') {
        $x_ref->$* = $coords->[0];
        $y_ref->$* = $coords->[1];
    }
}

sub final_password($map, $path, $wrap) {
    my $y = 1;
    my $x = 51;
    my $direction = 'R';

    while ($path =~ /((?:\d+)|(?:R|L))/g) {
        if (looks_like_number($1)) {
            move(\$x, \$y, $direction, $map, $wrap) for (1..$1);
        } else {
            $direction = $turns->{$1}{$direction};
        }
    }

    return 1000 * $y + 4 * $x + $facing_number->{$direction};
}

my $map = {};

my $y = 0;
while ((my $line = <>) ne "\n") {
    chomp $line;

    foreach my ($x, $tile) (builtin::indexed split //, $line) {
        $map->{($x+1) . ',' . ($y+1)} = $tile
            if $tile ne ' ';
    }

    $y++;
}

my $path = <>;
chomp $path;

say final_password($map, $path, \&wrap_2d);
