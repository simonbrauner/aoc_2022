#!/usr/bin/env perl

use v5.36;

use experimental qw{for_list builtin};

use List::Util qw{first};


my %movements = ('<' => [-1, 0], '>' => [1, 0],
                 '^' => [0, -1], 'v' => [0, 1]);

sub print_valley($valley) {
    for my $y (0..$valley->@*-1) {
        for my $x (0..$valley->[0]->@*-1) {
            print scalar $valley->[$y][$x]->@*;
        }
        say '';
    }
}

sub lcm($a, $b) {
    first { $_ % $a == 0 && $_ % $b == 0 } (1..$a*$b);
}

sub next_valley($valley) {
    my $next_valley = [];

    for my $y (0..$valley->@*-1) {
        for my $x (0..$valley->[0]->@*-1) {
            $next_valley->[$y][$x] //= [];

            foreach my $blizzard ($valley->[$y][$x]->@*) {
                my $movement = $movements{$blizzard};
                my $new_x = ($x + $movement->[0]) % $valley->[0]->@*;
                my $new_y = ($y + $movement->[1]) % $valley->@*;
                push $next_valley->[$new_y][$new_x]->@*, $blizzard;
            }
        }
    }

    return $next_valley;
}

sub accessible($valley, $start, $end, $x, $y) {
    return 1 if ($x == $start->[0] && $y == $start->[1])
        || ($x == $end->[0] && $y == $end->[1]);

    return 0 <= $x < $valley->[0]->@* && 0 <= $y < $valley->@*
        && $valley->[$y][$x]->@* == 0;
}

sub add_edges($next_valley, $graph, $from, $to, $start, $end, $x, $y) {
    my $edges = [];

    for my $movement (values %movements, [0, 0]) {
        my $new_x = $x + $movement->[0];
        my $new_y = $y + $movement->[1];

        push $edges->@*, "$to,$new_x,$new_y"
            if accessible($next_valley, $start, $end, $new_x, $new_y);
    }

    $graph->{"$from,$x,$y"} = $edges;
}

sub create_graph($valley, $start, $end) {
    my $graph = {};

    my $state_count = lcm(scalar $valley->@*, scalar $valley->[0]->@*);
    for my $layer (1..$state_count) {
        my $next_valley = next_valley($valley);

        my @part_of_arguments = ($next_valley, $graph, $layer - 1,
                                 $layer % $state_count, $start, $end);

        add_edges(@part_of_arguments, $start->@*);
        add_edges(@part_of_arguments, $end->@*);
        for my $y (0..$valley->@*-1) {
            for my $x (0..$valley->[0]->@*-1) {
                add_edges(@part_of_arguments, $x, $y)
                    if $valley->[$y][$x]->@* == 0;
            }
        }

        $valley = $next_valley;
    }

    return $graph;
}

sub start_location($value, $path, $state_count) {
    ($path % $state_count) . ',' . join ',', $value->@*;
}

sub is_end($value, $end) {
    $end = join ',', $end->@*;

    return $value =~ /\d+,$end/;
}

sub shortest_path($valley, $graph, @goals) {
    my $path = 0;
    my $state_count = lcm(scalar $valley->@*, scalar $valley->[0]->@*);

  OUTER: while (@goals > 1) {
      my @queue = (start_location(shift @goals, $path, $state_count), 0);
      my %seen;

      while (@queue) {
          my ($current, $length) = map { shift @queue } (1..2);
          if (is_end($current, $goals[0])) {
              $path += $length;
              next OUTER;
          }
          return $length if is_end($current, $goals[0]);

          foreach my $neighbor ($graph->{$current}->@*) {
              next if exists $seen{$neighbor};
              $seen{$neighbor} = undef;

              push @queue, $neighbor, $length + 1;
          }
      }
  }

    return $path;
}

my $valley = [];

foreach my ($y, $row) (builtin::indexed <>) {
    chomp $row;

    foreach my ($x, $tile) (builtin::indexed split //, $row) {
        next if $x == 0 || $x == (length $row) - 1 || $y == 0;

        $valley->[$y - 1][$x - 1] = $tile eq '.' ? [] : [$tile];
    }
}
pop $valley->@*;

my $start = [0, -1];
my $end = [$valley->[0]->@*-1, scalar $valley->@*];

my $graph = create_graph($valley, $start, $end);

say shortest_path($valley, $graph, $start, $end);
say shortest_path($valley, $graph, ($start, $end) x 2);
