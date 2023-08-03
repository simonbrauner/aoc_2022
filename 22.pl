#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};


my $turns = { R => { qw{R D D L L U U R} },
              L => { qw{R U U L L D D R} } };

my $map = {};

my $y = 0;
while ((my $line = <>) ne "\n") {
    chomp $line;

    foreach my ($x, $tile) (builtin::indexed split //, $line) {
        $map->{($x+1) . ',' . ($y+1)} = $tile;
    }

    $y++;
}

my $path = <>;
chomp $path;
