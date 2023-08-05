#!/usr/bin/env perl

use v5.36;


my $functions = { '+' => sub ($a, $b) { $a + $b }, '-' => sub ($a, $b) { $a - $b },
                  '*' => sub ($a, $b) { $a * $b }, '/' => sub ($a, $b) { $a / $b } };

sub eval_number($numbers, $monkey) {
    my @expr = $numbers->{$monkey}->@*;
    return $expr[0] if @expr == 1;

    return $functions->{$expr[1]}->(map { eval_number($numbers, $_) } ($expr[0], $expr[2]));
}

my $numbers = {};

my $file_content = join '', <>;
while ($file_content =~ /^(\w+): (.+)$/gm) {
    my @spaced = split ' ', $2;
    $numbers->{$1} = \@spaced;
}

say eval_number($numbers, 'root');
