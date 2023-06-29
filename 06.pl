#!/usr/bin/env perl

use v5.36;

use Set::Scalar;


sub packet_marker_index($datastream, $distinct_count) {
    my @neighbors = (split //, substr $datastream, 0, $distinct_count);

    for (my $index = $distinct_count; $index < length $datastream; $index++) {
        return $index if Set::Scalar->new(@neighbors)->size == $distinct_count;

        shift @neighbors;
        push @neighbors, substr $datastream, $index, 1;
    }
}

my $datastream = <>;
chomp $datastream;

say packet_marker_index($datastream, 4);
say packet_marker_index($datastream, 14);
