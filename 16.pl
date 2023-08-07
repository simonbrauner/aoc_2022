#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list};

use List::Util qw{max};


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

sub most_pressure($cave, $minutes, $pressure, $current, $visited) {
    my @subresults = ($pressure);

    $visited->{$current} = undef;

    foreach my ($tunnel, $distance) ($cave->{$current}{tunnels}->@*) {
        next if $minutes <= $distance || exists $visited->{$tunnel};

        my $new_time = $minutes - $distance - 1;
        my $new_pressure = $pressure + $new_time * $cave->{$tunnel}{flow_rate};

        push @subresults, most_pressure($cave, $new_time, $new_pressure, $tunnel, $visited);
    }

    delete $visited->{$current};

    return max @subresults;
}

my $cave = {};

my $file_content = join '', <>;
while ($file_content =~ /^Valve\ ([A-Z]+)\ has\ flow\ rate=(\d+);
                        \ tunnels?\ leads?\ to\ valves?\ ([ ,A-Z]+)$/gmx) {
    my @tunnels = split ', ', $3;
    $cave->{$1} = { flow_rate => $2, tunnels => \@tunnels };
}

my $simplified_cave = create_simplified_cave($cave);
say most_pressure($simplified_cave, 30, 0, 'AA', {});
