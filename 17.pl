#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list};

use Clone qw{clone};


my @shapes = (
    [3, 4, 4, 4, 5, 4, 6, 4],
    [3, 5, 4, 4, 4, 5, 4, 6, 5, 5],
    [3, 4, 4, 4, 5, 4, 5, 5, 5, 6],
    [3, 4, 3, 5, 3, 6, 3, 7],
    [3, 4, 3, 5, 4, 4, 4, 5]
);

my %movements = ('<' => [-1, 0], '>' => [1, 0], 'v' => [0, -1]);

sub print_chamber($tower, $height) {
    for (my $y = $height; $y >= 0; $y--) {
        for my $x (0..8) {
            if ($x == 0 || $x == 8) {
                print $y == 0 ? '+' : '|';
            } else {
                print $y == 0 ? '-' : (exists $tower->{"$x,$y"} ? '#' : '.');
            }
        }

        say '';
    }
}

sub next_shape($height) {
    my $shape = clone($shapes[0]);
    push @shapes, shift @shapes;

    for (my $y_coord = 1; $y_coord < $shape->@*; $y_coord += 2) {
        $shape->[$y_coord] += $height;
    }

    return $shape;
}

sub try_move($tower, $height, $shape, $direction) {
    my ($dx, $dy) = $movements{$direction}->@*;

    foreach my ($x, $y) (map { \$_ } $shape->@*) {
        if (!(0 < $x->$* + $dx < 8)
                || exists $tower->{($x->$* + $dx) . ',' . ($y->$* + $dy)}) {
            return 0;
        }
    }

    foreach my ($x, $y) (map { \$_ } $shape->@*) {
        $x->$* += $dx;
        $y->$* += $dy;
    }

    return 1;
}

sub place_shape($tower, $shape) {
    foreach my ($x, $y) ($shape->@*) {
        $tower->{"$x,$y"} = undef;
    }
}

sub max_y_coord($heightref, $shape) {
    foreach my ($x, $y) ($shape->@*) {
        $heightref->$* = $y if $y > $heightref->$*;
    }
}

sub build_tower($stones, @jet_pattern) {
    my $tower = {};
    $tower->{"$_,0"} = undef for (1..7);

    my $height = 0;

  OUTER: for (1..$stones) {
      my $shape = next_shape($height);

      while (1) {
          push @jet_pattern, my $left_right = shift @jet_pattern;

          try_move($tower, $height, $shape, $left_right);

          if (!try_move($tower, $height, $shape, 'v')) {
              place_shape($tower, $shape);
              max_y_coord(\$height, $shape);
              next OUTER;
          }
      }
  }

    # print_chamber($tower, $height);
    return $height;
}

my @jet_pattern = split //, <>;
splice @jet_pattern, @jet_pattern - 1;

say build_tower(2022, @jet_pattern);
