#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum};
use List::MoreUtils qw{firstidx};


sub mixed_numbers($times, @numbers) {
    my @original = @numbers;

    for (1..$times) {
        foreach my $current (@original) {
            my $index = firstidx { $_ eq $current } @numbers;

            splice @numbers, $index, 1;

            my $new_index = ($index + $current->$*) % @numbers;

            if ($new_index == 0) {
                push @numbers, $current;
            } else {
                splice @numbers, $new_index, 0, $current;
            }
        }
    }

    return @numbers;
}

sub grove_coordinates($key, $times, @numbers) {
    $_->$* *= $key foreach @numbers;
    @numbers = mixed_numbers($times, @numbers);

    my $zero_index = firstidx { $_->$* eq 0 } @numbers;

    return sum map { $numbers[($_ + $zero_index) % @numbers]->$* } (1000, 2000, 3000);
}

my @numbers;

foreach my $line (<>) {
    chomp $line;

    push @numbers, \$line;
}

say grove_coordinates(1, 1, @numbers);
say grove_coordinates(811589153, 10, @numbers);
