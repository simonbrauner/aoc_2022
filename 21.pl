#!/usr/bin/env perl

use v5.36;


my $functions = { '+' => sub ($a, $b) { $a + $b }, '-' => sub ($a, $b) { $a - $b },
                  '*' => sub ($a, $b) { $a * $b }, '/' => sub ($a, $b) { $a / $b } };

sub eval_number($numbers, $monkey) {
    my @expr = $numbers->{$monkey}->@*;
    return $expr[0] if @expr == 1;

    return $functions->{$expr[1]}->(map { eval_number($numbers, $_) } ($expr[0], $expr[2]));
}

sub depends_on_human($numbers, $monkey) {
    my @expr = $numbers->{$monkey}->@*;
    return $monkey eq 'humn' if @expr == 1;

    return depends_on_human($numbers, $expr[0]) || depends_on_human($numbers, $expr[2]);
}

sub string_expr($numbers, $monkey) {
    my @expr = $numbers->{$monkey}->@*;
    return $expr[0] if @expr == 1;

    my ($left, $right) = map { depends_on_human($numbers, $_)
                                   ? string_expr($numbers, $_)
                                   : eval_number($numbers, $_) } ($expr[0], $expr[2]);

    return "($left $expr[1] $right)";
}

my $numbers = {};

my $file_content = join '', <>;
while ($file_content =~ /^(\w+): (.+)$/gm) {
    my @spaced = split ' ', $2;
    $numbers->{$1} = \@spaced;
}

say eval_number($numbers, 'root');
$numbers->{root}[1] = '=';
$numbers->{humn}->@* = qw{x};
say string_expr($numbers, 'root');  # https://quickmath.com/
