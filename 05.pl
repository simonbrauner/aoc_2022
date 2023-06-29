#!/usr/bin/env perl

use v5.36;


my @stacks;
my @movements;

while (my $line = <>) {
    chomp $line;

    last if $line eq '';

    my $index = 0;
    while ($line =~ /(?:(?:   )|(?:\[([A-Z])\])).?/g) {
        $index++;
        unshift $stacks[$index]->@*, $1 if defined $1;
    }
}

while (my $line = <>) {
    chomp $line;

    my @movement = $line =~ /^move (\d+) from (\d+) to (\d+)$/;
    push @movements, \@movement;
}
