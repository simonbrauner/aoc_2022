#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};

use List::Util qw{sum max product};


sub transposed_forest(@forest) {
    my @transposed;

    for my $index (0..@forest-1) {
        my @tree_row = map { $_->[$index] } @forest;

        push @transposed, \@tree_row;
    }

    return @transposed;
}

sub print_forest(@forest) {
    foreach my $tree_row (@forest) {
        print $_->{visible} foreach $tree_row->@*;
        say '';
    }
}

sub compute_edges(@forest) {
    $_->[0]{visible} = 1 foreach @forest;
}

sub compute_lines(@forest) {
    foreach my $tree_row (@forest) {
        my @indices = map { 0 } (0..9);
        my $highest = $tree_row->[0];

        foreach my ($index, $tree) (builtin::indexed $tree_row->@*) {
            push $tree->{distances}->@*, $index - max @indices[$tree->{height}..9];
            $indices[$tree->{height}] = $index;

            if ($tree->{height} > $highest->{height}) {
                $tree->{visible} = 1;
                $highest = $tree;
            }
        }
    }
}

sub compute_forest(@forest) {
    my @reversed = transposed_forest(reverse transposed_forest(@forest));
    my @transposed = transposed_forest(@forest);
    my @both = transposed_forest(reverse @forest);

    foreach my $orientation (\@forest, \@reversed, \@transposed, \@both) {
        compute_edges($orientation->@*);
        compute_lines($orientation->@*);
    }
}

sub count_visible(@forest) {
    sum map { $_->{visible} } map { $_->@* } @forest
}

sub maximal_distances(@forest) {
    max map { product $_->{distances}->@* } map { $_->@* } @forest
}

my @forest;

foreach my $line (<>) {
    chomp $line;

    my @tree_line = map { { height => $_, visible => 0,
                            distances => [] } } split //, $line;
    push @forest, \@tree_line;
}

compute_forest(@forest);

say count_visible(@forest);
say maximal_distances(@forest);
