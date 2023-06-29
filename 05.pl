#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list};

use Clone qw{clone};


sub stack_tops(@stacks) {
    print $_->[$_->@*-1] foreach grep { defined $_ } (@stacks);
    say '';
}

sub move_crates($reverse, $movements, @stacks) {
    foreach my $movement ($movements->@*) {
        my ($count, $source, $destination) = $movement->@*;

        push $stacks[$destination]->@*,
            (pop $stacks[$source]->@*) for (1..$count);
    }

    stack_tops(@stacks);
}

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

move_crates(0, \@movements, clone(\@stacks)->@*);
move_crates(1, \@movements, @stacks);
