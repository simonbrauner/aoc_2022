#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum};


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

sub make_edges_visible(@forest) {
    $_->[0]{visible} = 1 foreach @forest;
}

sub make_lines_visible(@forest) {
    foreach my $tree_row (@forest) {
        my $highest = $tree_row->[0];

        foreach my $tree ($tree_row->@*) {
            if ($tree->{height} > $highest->{height}) {
                $tree->{visible} = 1;
                $highest = $tree;
            }
        }
    }
}

sub make_forest_visible(@forest) {
    my @reversed = transposed_forest(reverse transposed_forest(@forest));
    my @transposed = transposed_forest(@forest);
    my @both = transposed_forest(reverse @forest);

    foreach my $orientation (\@forest, \@reversed, \@transposed, \@both) {
        make_edges_visible($orientation->@*);
        make_lines_visible($orientation->@*);
    }
}

sub count_visible(@forest) {
    sum map { $_->{visible} } map { $_->@* } @forest
}

my @forest;

foreach my $line (<>) {
    chomp $line;

    my @tree_line = map { { height => $_, visible => 0 } } split //, $line;
    push @forest, \@tree_line;
}

make_forest_visible(@forest);

say count_visible(@forest);
