#!/usr/bin/env perl

use v5.36;

use List::Util qw{min max};


sub add_air($map) {
    my $max_y = $map->@*+1;

    for my $y (0..$max_y) {
        for my $x (500-$y..500+$y) {
            if ($y == $max_y) {
                $map->[$y]{$x} = '#';
            } else {
                $map->[$y]{$x} //= '.';
            }
        }
    }
}

sub create_map(@rocks) {
    my @map = ({ 500 => '+' });

    foreach my $rock (@rocks) {
        my ($x, $y) = split ',', $rock->[0];

        foreach my $edge ($rock->@*) {
            my ($new_x, $new_y) = split ',', $edge;

            do {
                $x += $x < $new_x ? 1 : -1 if $x != $new_x;
                $y += $y < $new_y ? 1 : -1 if $y != $new_y;

                $map[$y]->{$x} = '#';
            } while $x != $new_x || $y != $new_y;
        }
    }

    add_air(\@map);

    return @map;
}

sub fall_sand($map, $limit) {
    my ($x, $y) = (500, 0);

  OUTER: while (1) {
      $y++;
      return 0 if $y > $limit;

      foreach my $dx (0, -1, 2) {
          $x += $dx;

          next OUTER if ($map->[$y]{$x} eq '.');
      }

      if ($map->[$y - 1]{$x - 1} ne 'o') {
          $map->[$y - 1]{$x - 1} = 'o';
          return 1;
      }

      return 0;
  }
}

sub come_to_rest($map, $limit = $map->@*) {
    my $counter = 0;

    $counter++ while fall_sand($map, $limit);

    return $counter;
}

my @rocks;

foreach my $line (<>) {
    chomp $line;

    my @rock = split ' -> ', $line;
    push @rocks, \@rock;
}

my @map = create_map(@rocks);

say my $on_rock = come_to_rest(\@map, @map-2);
say $on_rock + come_to_rest(\@map);

