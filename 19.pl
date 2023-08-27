#!/usr/bin/env perl

use v5.36;


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

my $numbers = [];

my $file_content = join '', <>;
while ($file_content =~ /(\d+)/g) {
    push $numbers->@*, $1;
}

my $blueprints = parse_blueprints($numbers);
