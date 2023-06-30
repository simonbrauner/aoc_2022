#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum};


sub make_edges_visible($forest) {
    my $max_x = $forest->[0]->@* - 1;
    my $max_y = $forest->@* - 1;

    for (my $y = 0; $y <= $max_y; $y++) {
        for (my $x = 0; $x <= $max_x; $x++) {
            $forest->[$y][$x]{visible} = 1
                if ($x % $max_x == 0 || $y % $max_y == 0);
        }
    }
}

sub count_visible($forest) {
    sum map { $_->{visible} } map { $_->@* } $forest->@*
}

my @forest;

foreach my $line (<>) {
    chomp $line;

    my @tree_line = map { { height => $_, visible => 0 } } split //, $line;
    push @forest, \@tree_line;
}

make_edges_visible(\@forest);

say count_visible(\@forest);
