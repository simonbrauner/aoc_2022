#!/usr/bin/env perl

use v5.36;


my %shape_scores = ( Rock => 1, Paper => 2, Scissors => 3 );
my %result_scores = ( Win => 6, Draw => 3, Lose => 0 );

sub result($me, $opponent) {
    return 'Draw' if $me eq $opponent;
    return 'Win' if $shape_scores{$me} == $shape_scores{$opponent} % 3 + 1;
    return 'Lose';
}

sub round_score($me, $opponent) {
    $shape_scores{$me} + $result_scores{result($me, $opponent)}
}

my %encryption = ( A => 'Rock', B => 'Paper', C => 'Scissors',
                   X => 'Rock', Y => 'Paper', Z => 'Scissors' );

sub total_score(@lines) {
    my $score = 0;

    $score += round_score(map { $encryption{$_} } split ' ', $_) foreach @lines;

    return $score;
}

my @lines;

foreach my $line (<>) {
    chomp $line;
    push @lines, $line;

    my ($left, $right) = split ' ', $line;
}

say total_score(@lines);
