#!/usr/bin/env perl

use v5.36;

use Set::Scalar;


sub packet_marker_index($datastream) {
    my @four = (split //, substr $datastream, 0, 4);

    for (my $index = 4; $index < length $datastream; $index++) {
        return $index if Set::Scalar->new(@four)->size == 4;

        shift @four;
        push @four, substr $datastream, $index, 1;
    }
}

my $datastream = <>;
chomp $datastream;

say packet_marker_index($datastream);

