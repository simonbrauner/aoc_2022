#!/usr/bin/env perl

use v5.36;

use List::Util qw{product};

use List::MoreUtils qw{mesh};


sub create_operation($operation) {
    my @keys = qw{left operator right};
    my @values = split ' ', $operation;

    my %result = mesh @keys, @values;
    return \%result;
}

sub Monkey::new($class, $items, $operation, $test, $true, $false) {
    my @items = split ', ', $items;

    return bless {
        items => \@items, operation => create_operation($operation),
        divisible_by => $test, true => $true, false => $false, inspected => 0,
    }, $class;
}

sub two_most_active_monkeys(@monkeys) {
    product ((sort { $b <=> $a } map { $_->{inspected} } @monkeys)[0..1]);
}

my @monkeys;

my $file_content = join '', <>;
while ($file_content =~ /Monkey\s\d+:\s+
                        Starting\sitems:\s(.*)\s+
                        Operation:\snew\s=\s(.*)\s+
                        Test:\sdivisible\sby\s(\d+)\s+
                        If\strue:\sthrow\sto\smonkey\s(\d+)\s+
                        If\sfalse:\sthrow\sto\smonkey\s(\d+)/gx) {
    push @monkeys, Monkey->new(@{^CAPTURE});
}

say two_most_active_monkeys(@monkeys);
