#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum};


sub signal_strengths(@program) {
    my @strengths;
    my $register = 1;

    my $cycles = 1;
    foreach my $instruction (@program) {
        $register += $instruction if defined $instruction;
        $cycles++;

        if ($cycles % 40 == 20) {
            push @strengths, $cycles * $register;
        }
    }

    return @strengths;
}

my @program;

foreach my $line (<>) {
    push @program, undef;
    push @program, $1 if $line =~ /addx (-?\d+)/;
}

say sum signal_strengths(@program);
