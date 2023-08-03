#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};

use List::Util qw{min max any all};
use List::MoreUtils qw{firstidx};

use Clone qw{clone};


my %directions = (N => [0, -1], S => [0, 1], W => [-1, 0], E => [1, 0], 0 => [0, 0]);

my @priorities = ([qw{N NE NW}], [qw{S SE SW}], [qw{W NW SW}], [qw{E NE SE}]);

sub print_elves($elves) {
    my @x_coords = map { $_ =~ /(.*),/; $1 } keys $elves->%*;
    my @y_coords = map { $_ =~ /,(.*)/; $1 } keys $elves->%*;

    for (my $y = min @y_coords; $y <= max @y_coords; $y++) {
        for (my $x = min @x_coords; $x <= max @x_coords; $x++) {
            print exists $elves->{"$x,$y"} ? '#' : '.';
        }

        say '';
    }

    say '';
}

sub tile_free($elves, $coords, $direction) {
    my ($x, $y) = split ',', $coords;

    foreach my $orthogonal (split //, $direction) {
        $x += $directions{$orthogonal}->[0];
        $y += $directions{$orthogonal}->[1];
    }

    return !exists $elves->{"$x,$y"};
}

sub elf_active($elves, $priorities, $coords) {
    any { !tile_free($elves, $coords, $_) } (map { $_->@* } $priorities->@*)
}

sub create_proposal($elves, $priorities, $coords) {
    foreach my $priority ($priorities->@*) {
        if (all { tile_free($elves, $coords, $_) } $priority->@*) {
            my ($x, $y) = split ',', $coords;

            $x += $directions{$priority->[0]}->[0];
            $y += $directions{$priority->[0]}->[1];

            return { orthogonal => $priority->[0], coords => "$x,$y" };
        }
    }

    return undef;
}

sub turn($elves, $priorities, $end = undef) {
    my @active = grep { elf_active($elves, $priorities, $_) } keys $elves->%*;
    my @passive = grep { !elf_active($elves, $priorities, $_) } keys $elves->%*;

    if (@active == 0) {
        $end->$* = 1 if defined $end;
        return;
    }

    my %proposals = map { $_ => create_proposal($elves, $priorities, $_) } @active;
    my %proposal_counts;
    $proposal_counts{$_->{coords}}++ foreach grep { defined $_ } values %proposals;

    my %new_elves;
    my $first_index = $priorities->@*;
    foreach my ($old, $new) (%proposals) {
        if (!defined $new || $proposal_counts{$new->{coords}} != 1) {
            $new_elves{$old} = undef;
        } else {
            $new_elves{$new->{coords}} = undef;
            $first_index = min($first_index,
                               firstidx { $_->[0] eq $new->{orthogonal} } $priorities->@*);
        }
    }

    $elves->%* = (%new_elves, map { $_ => undef } @passive);

    push $priorities->@*, (splice $priorities->@*, $first_index, 1);
}

sub rectangle_side($elves, $regex) {
    my @coords =  map { $_ =~ $regex; $1 } keys $elves->%*;
    return max(@coords) - min(@coords) + 1;
}

sub empty_ground_tiles($elves, $priorities) {
    turn($elves, $priorities) for (1..10);

    return rectangle_side($elves, qr{(.*),}) * rectangle_side($elves, qr{,(.*)})
        - keys $elves->%*;
}

sub passive_turn_number($elves, $priorities) {
    my $turn_number = 0;

    my $end = 0;
    while (!$end) {
        turn($elves, $priorities, \$end);
        $turn_number++;
    }

    return $turn_number;
}

my $elves = {};

foreach my ($y, $row) (builtin::indexed <>) {
    chomp $row;

    foreach my ($x, $tile) (builtin::indexed split //, $row) {
        $elves->{"$x,$y"} = undef
            if $tile eq '#';
    }
}

say empty_ground_tiles(clone($elves), clone(\@priorities));
say passive_turn_number($elves, \@priorities);
