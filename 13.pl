#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};

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

sub sum_of_valid_indices(@pairs) {
    my $sum = 0;

    foreach my ($index, $pair) (builtin::indexed @pairs) {
        $sum += $index + 1 if is_pair_valid($pair->@*);
    }

    return $sum;
}

my @packets;

my $file_content = join '', <>;
while ($file_content =~ /([^\n]*)\n([^\n]*)\n\n?/g) {
    push @packets, [ eval $1, eval $2 ];
}

say sum_of_valid_indices(@packets);
