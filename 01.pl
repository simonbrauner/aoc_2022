#!/usr/bin/env perl

use v5.36;

use List::Util qw{max sum};


sub most_calories($count, @elves) {
    sum ((sort { $a <=> $b } map { sum $_->@* } @elves)[@elves-$count..@elves-1])
}


my @elves;
my $current_elf = ();

foreach my $line (<>) {
    chomp $line;

    if ($line eq '') {
        push @elves, $current_elf;
        $current_elf = ();
    } else {
        push $current_elf->@*, $line;
    }
}

push @elves, $current_elf;

say most_calories(1, @elves);
say most_calories(3, @elves);
