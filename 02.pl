#!/usr/bin/env perl

use v5.36;


my %shape_scores = ( Rock => 1, Paper => 2, Scissors => 3 );
my %result_scores = ( Win => 6, Draw => 3, Lose => 0,
                      Z => 6, Y => 3, X => 0 );

sub result($me, $opponent) {
    return 'Draw' if $me eq $opponent;
    return 'Win' if $shape_scores{$me} == $shape_scores{$opponent} % 3 + 1;
    return 'Lose';
}

sub round_score($opponent, $me) {
    $shape_scores{$me} + $result_scores{result($me, $opponent)}
}

my %decryption = ( A => 'Rock', B => 'Paper', C => 'Scissors',
                   X => 'Rock', Y => 'Paper', Z => 'Scissors' );

sub total_score_1(@lines) {
    my $score = 0;

    $score += round_score(map { $decryption{$_} } split ' ', $_) foreach @lines;

    return $score;
}

sub total_score_2(@lines) {
    my $score = 0;

    foreach my $line (@lines) {
        my ($opponent, $outcome) = split ' ', $line;
        $opponent = $decryption{$opponent};

        foreach my $shape (qw{Rock Paper Scissors}) {
            $score += round_score($opponent, $shape)
                if $result_scores{result($shape, $opponent)} eq $result_scores{$outcome};
        }
    }

    return $score;
}

my @lines;

foreach my $line (<>) {
    chomp $line;
    push @lines, $line;
}

say total_score_1(@lines);
say total_score_2(@lines);
