#!/usr/bin/env perl

use v5.36;

use List::Util qw{max sum};


sub most_calories(@elves) {
    max map { sum $_->@* } @elves;
}


my @elves;
my $current_elf = ();

foreach my $line (<>) {
    chomp $line;

    if ($line eq '') {
        push @elves, $current_elf;
        $current_elf = ();
    } else {
        push $current_elf->@*, int($line);
    }
}

push @elves, $current_elf;

say most_calories(@elves);
