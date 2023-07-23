#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list};

use List::Util qw{all min};


sub replace($value) {
    ref $value eq '' ? [$value] : $value;
}

sub is_pair_valid {
    my ($left, $right) = @_;

    if (all { ref $_ eq '' } @_) {
        return if $left == $right;
        return $left < $right;

    } elsif (all { ref $_ eq 'ARRAY' } @_) {
        my @lengths = map { scalar $_->@* } @_;

        for (my $index = 0; $index < min @lengths; $index++) {
            my $result = is_pair_valid(map { $_->[$index] } @_);
            return $result if defined $result;
        }

        return is_pair_valid(@lengths);
    }

    return is_pair_valid(map { replace($_) } @_);
}

sub sum_of_valid_indices(@packets) {
    my $sum = 0;
    my $index = 0;

    foreach my ($left, $right) (@packets) {
        $index++;
        $sum += $index if is_pair_valid($left, $right);
    }

    return $sum;
}

my @packets;

my $file_content = join '', <>;
while ($file_content =~ /^([\d,\[\]]+)$/gm) {
    push @packets, eval $1;
}

say sum_of_valid_indices(@packets);
