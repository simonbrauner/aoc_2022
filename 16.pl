#!/usr/bin/env perl

use v5.36;


sub create_layered_graph($vertices) {
    my $graph = [];

    foreach my $vertex (keys $vertices->%*) {
        for my $layer (0..30) {
            $graph->[$layer]{$vertex} = { name => $vertex };

            if ($layer - 1 >= 0) {
                push $graph->[$layer]{$vertex}{neighbors}->@*,
                    { $graph->[$layer - 1]{$_} => 0 }
                    foreach $vertices->{$vertex}{tunnels}->@*;
            }

            if ($layer - 2 >= 0) {
                push $graph->[$layer]{$vertex}{neighbors}->@*,
                    { $graph->[$layer - 2]{$_} => -$vertices->{$vertex}{flow_rate} * ($layer - 2) }
                    foreach $vertices->{$vertex}{tunnels}->@*;
            }
        }
    }

    return $graph;
}

my $cave = {};

my $file_content = join '', <>;
while ($file_content =~ /^Valve\ ([A-Z]+)\ has\ flow\ rate=(\d+);
                        \ tunnels?\ leads?\ to\ valves?\ ([ ,A-Z]+)$/gmx) {
    my @tunnels = split ', ', $3;
    $cave->{$1} = { flow_rate => $2, tunnels => \@tunnels };
}

my $graph = create_layered_graph($cave);
