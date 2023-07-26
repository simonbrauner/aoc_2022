#!/usr/bin/env perl

use v5.36;


my $ROW = 2000000;

sub manhattan_distance($x, $y, $other_x, $other_y) {
    abs($x - $other_x) + abs($y - $other_y);
}

sub new_sensor($x, $y, $beacon_x, $beacon_y) {
    { x => $x, y => $y,
      distance => manhattan_distance($x, $y, $beacon_x, $beacon_y) }
}

sub positions_without_beacon($sensors, $beacons) {
    my %result;

    foreach my $sensor ($sensors->@*) {
        for my $dx (0..($sensor->{distance} - abs($sensor->{y} - $ROW))) {
            $result{$sensor->{x} - $dx} = undef;
            $result{$sensor->{x} + $dx} = undef;
        }
    }

    foreach my $beacon ($beacons->@*) {
        delete $result{$beacon->{x}} if $beacon->{y} == $ROW;
    }

    return scalar %result;
}

my @sensors;
my @beacons;

my $file_content = join '', <>;
while ($file_content =~ /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/g) {
    push @sensors, new_sensor(@{^CAPTURE});
    push @beacons, { x => $3, y => $4 };
}

say positions_without_beacon(\@sensors, \@beacons);
