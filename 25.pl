#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum};


package SNAFU {
    use List::Util qw{max};

    my %to_normal = ('=' => -2, '-' => -1, 0 => 0, 1 => 1, 2 => 2);
    my %from_normal = (-2 => '=', -1 => '-', 0 => 0, 1 => 1, 2 => 2);

    sub new($class, $number) {
        bless \$number, $class;
    }

    sub _plus($lhs, $rhs, $,) {
        my $number = '';
        my $current = 0;
        my @left = reverse split //, $lhs->$*;
        my @right = reverse split //, $rhs->$*;

        for my $index (0..max(scalar @left, scalar@right)-1) {
            $current += $to_normal{$_} foreach (($left[$index] // 0), ($right[$index] // 0));

            my $sign = abs($current) > 2 ? ($current > 0 ? 1 : -1) : 0;

            $number = $from_normal{$current - 5 * $sign} . $number;
            $current = $sign;
        }

        $number = $current . $number if $current != 0;

        return SNAFU->new($number);
    }

    sub _string($lhs, $, $,) {
        $lhs->$* eq '' ? 0 : $lhs->$*
    }

    use overload '+' => \&_plus, '""' => \&_string;
}


my @numbers;

foreach my $line (<>) {
    chomp $line;

    push @numbers, SNAFU->new($line);
}

say sum @numbers;
