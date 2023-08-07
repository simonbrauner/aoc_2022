#!/usr/bin/env perl

use v5.36;


sub is_simple($cave, $valve) {
    $valve eq 'AA' || $cave->{$valve}{flow_rate} != 0
}

sub add_shortest_paths($cave, $simplified, $from) {
    my @queue = ($from, 0);
    my %seen = ($from => undef);

    while (@queue) {
        my ($current, $distance) = map { shift @queue } (1..2);

        if (is_simple($cave, $current) && $current ne $from) {
            push $simplified->{$from}{tunnels}->@*, ($current, $distance)
        }

        foreach my $tunnel ($cave->{$current}{tunnels}->@*) {
            next if exists $seen{$tunnel};
            $seen{$tunnel} = undef;
            push @queue, ($tunnel, $distance + 1);
        }
    }
}

sub create_simplified_cave($cave) {
    my $simplified = {};

    foreach my $valve (keys $cave->%*) {
        if (is_simple($cave, $valve)) {
            $simplified->{$valve} = { flow_rate => $cave->{$valve}{flow_rate}, tunnels => [] };
            add_shortest_paths($cave, $simplified, $valve);
        }
    }

    return $simplified;
}

my $cave = {};

my $file_content = join '', <>;
while ($file_content =~ /^Valve\ ([A-Z]+)\ has\ flow\ rate=(\d+);
                        \ tunnels?\ leads?\ to\ valves?\ ([ ,A-Z]+)$/gmx) {
    my @tunnels = split ', ', $3;
    $cave->{$1} = { flow_rate => $2, tunnels => \@tunnels };
}

my $simplified_cave = create_simplified_cave($cave);
