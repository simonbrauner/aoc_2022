#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list};

use List::Util qw{all min};


sub replace($value) {
    ref $value eq '' ? [$value] : $value;
}

sub compare_pair {
    my ($left, $right) = @_;

    return $left - $right
        if all { ref $_ eq '' } @_;

    if (all { ref $_ eq 'ARRAY' } @_) {
        my @lengths = map { scalar $_->@* } @_;

        for (my $index = 0; $index < min @lengths; $index++) {
            my $result = compare_pair(map { $_->[$index] } @_);
            return $result if $result != 0;
        }

        return compare_pair(@lengths);
    }

    return compare_pair(map { replace($_) } @_);
}

sub sum_of_valid_indices(@packets) {
    my $sum = 0;
    my $index = 0;

    foreach my ($left, $right) (@packets) {
        $index++;
        $sum += $index if compare_pair($left, $right) < 0;
    }

    return $sum;
}

my @packets;

my $file_content = join '', <>;
while ($file_content =~ /^([\d,\[\]]+)$/gm) {
    push @packets, eval $1;
}

say sum_of_valid_indices(@packets);
