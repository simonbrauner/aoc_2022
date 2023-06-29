#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list};


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

sub move_crates($stacks, @movements) {
    foreach my $movement (@movements) {
        my ($count, $source, $destination) = $movement->@*;

        push $stacks->[$destination]->@*,
            (pop $stacks->[$source]->@*) for (1..$count);
    }
}

sub stack_tops($stacks) {
    print pop $_->@* foreach grep { defined $_ } ($stacks->@*);
    say '';
}

while (my $line = <>) {
    chomp $line;

    my @movement = $line =~ /^move (\d+) from (\d+) to (\d+)$/;
    push @movements, \@movement;
}

move_crates(\@stacks, @movements);
stack_tops(\@stacks);
