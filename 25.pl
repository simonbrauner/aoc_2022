#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum};


package SNAFU {
    sub new($class, $number) {
        bless \$number, $class;
    }

    sub _plus($lhs, $rhs, $,) {
        return SNAFU->new('----');
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
