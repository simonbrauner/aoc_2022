#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list};

use List::Util qw{max all sum};

use Clone qw{clone};


my $materials = [qw{ore clay obsidian geode}];

my $initial_state = {};
foreach my $material ($materials->@*) {
    $initial_state->{$material} = 0;
    $initial_state->{"${material}_robots"} = 0 if $material ne 'geode';
}
$initial_state->{ore_robots}++;
$initial_state->{minute} = 1;

my $last_minute = 24;


sub parse_blueprints($numbers) {
    my $blueprints = [];

    while ($numbers->@*) {
        my $blueprint = {};

        die if shift $numbers->@* != $blueprints->@*+1;
        $blueprint->{ore} = { ore => shift $numbers->@* };
        $blueprint->{clay} = { ore => shift $numbers->@* };
        $blueprint->{obsidian} = { ore => shift $numbers->@*,
                                   clay => shift $numbers->@* };
        $blueprint->{geode} = { ore => shift $numbers->@*,
                                obsidian => shift $numbers->@* };

        push $blueprints->@*, $blueprint;
    }

    return $blueprints;
}

sub add_materials($state) {
    foreach my $material ($materials->@*) {
        $state->{$material} += $state->{"${material}_robots"} if $material ne 'geode';
    }
}

sub state_valid($state) {
    all { $_ >= 0 } values $state->%*
}

sub previous_robots_constructed($blueprint, $state, $robot_cost) {
    all { $state->{"${_}_robots"} != 0 } keys $robot_cost->%*
}

sub robot_can_be_constructed($blueprint, $state, $robot_cost) {
    foreach my ($material, $amount) ($robot_cost->%*) {
        return 0 if $state->{$material} < $amount;
    }

    return 1;
}

sub construct_robot($blueprint, $state, $robot_type, $robot_cost) {
    while (!robot_can_be_constructed($blueprint, $state, $robot_cost)) {
        add_materials($state);
        $state->{minute}++;

        return if $state->{minute} >= $last_minute;
    }

    foreach my ($material, $amount) ($robot_cost->%*) {
        $state->{$material} -= $amount;
    }

    add_materials($state);

    if ($robot_type eq 'geode') {
        $state->{geode} += $last_minute - $state->{minute};
    } else {
        $state->{"${robot_type}_robots"}++;
    }

    $state->{minute}++;
}

sub most_possible_geodes($minute) {
    my $result = 0;

    for (my $count = $minute; $count < $last_minute; $count++) {
        $result += $last_minute - $count;
    }

    return $result;
}

sub max_geodes($blueprint, $state, $result) {
    return if $state->{minute} > $last_minute;
    $result->$* = $state->{geode} if $result->$* < $state->{geode};
    return if $state->{minute} >= $last_minute - 1
        || $state->{geode} + most_possible_geodes($state->{minute}) <= $result->$*;

    foreach my ($robot_type, $robot_cost) ($blueprint->%*) {
        next unless previous_robots_constructed($blueprint, $state, $robot_cost);

        my $new_state = clone($state);

        construct_robot($blueprint, $new_state, $robot_type, $robot_cost);

        max_geodes($blueprint, $new_state, $result);
    }
}

sub quality_levels($blueprints) {
    my @levels;
    my $id = 0;

    foreach my $blueprint ($blueprints->@*) {
        my $result = 0;

        max_geodes($blueprint, clone($initial_state), \$result);

        push @levels, ++$id * $result;
    }

    return @levels;
}

my $numbers = [];

my $file_content = join '', <>;
while ($file_content =~ /(\d+)/g) {
    push $numbers->@*, $1;
}

my $blueprints = parse_blueprints($numbers);

say sum quality_levels($blueprints);
