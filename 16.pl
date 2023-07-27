#!/usr/bin/env perl

use v5.36;


my $cave = {};

my $file_content = join '', <>;
while ($file_content =~ /^Valve\ ([A-Z]+)\ has\ flow\ rate=(\d+);
                        \ tunnels?\ leads?\ to\ valves?\ ([ ,A-Z]+)$/gmx) {
    my @tunnels = split ', ', $3;
    $cave->{$1} = { flow_rate => $2, tunnels => \@tunnels };
}
