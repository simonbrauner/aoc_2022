#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum};

use Clone qw{clone};


my $initial_state = { ore => 0, clay => 0, obsidian => 0, geode => 0,
                      ore_robots => 1, clay_robots => 0,
                      obsidian_robots => 0, geode_robots => 0 };

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

sub max_geodes($blueprint, $state, $minute) {

}

sub quality_levels($blueprints) {
    my @levels;
    my $id = 0;

    foreach my $blueprint ($blueprints->@*) {
        push @levels,
            ++$id * max_geodes($blueprint, clone($initial_state), 1);
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
