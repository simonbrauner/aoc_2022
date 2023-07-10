#!/usr/bin/env perl

use v5.36;

use List::Util qw{product};

use List::MoreUtils qw{mesh};

use Clone qw{clone};


sub create_operation($operation) {
    my @keys = qw{left operator right};
    my @values = split ' ', $operation;

    my %result = mesh @keys, @values;
    return \%result;
}

sub worry_level($value, $old) {
    $value eq 'old' ? $old : $value;
}

sub Monkey::new($class, $items, $operation, $test, $true, $false) {
    my @items = split ', ', $items;

    return bless {
        items => \@items, operation => create_operation($operation),
        divisible_by => $test, true => $true, false => $false, inspected => 0,
    }, $class;
}

sub Monkey::process_item($self, $item, $operation, @monkeys) {
    my ($left, $right) = map { worry_level($self->{operation}{$_}, $item) } qw{left right};
    $item = $self->{operation}{operator} eq '+' ? $left + $right : $left * $right;

    $self->{inspected}++;

    $item = $operation->($item);

    push $monkeys[$item % $self->{divisible_by} == 0
                  ? $self->{true} : $self->{false}]->{items}->@*, $item;
}

sub Monkey::turn($self, $operation, @monkeys) {
    while (my $item = shift $self->{items}->@*) {
        $self->process_item($item, $operation, @monkeys);
    }
}

sub round($operation, @monkeys) {
    $_->turn($operation, @monkeys) foreach @monkeys;
}

sub two_most_active_monkeys(@monkeys) {
    product ((sort { $b <=> $a } map { $_->{inspected} } @monkeys)[0..1]);
}

sub simulate_monkeys($rounds, $operation, @monkeys) {
    round($operation, @monkeys) foreach (1..$rounds);

    return two_most_active_monkeys(@monkeys);
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

say simulate_monkeys(20, sub($a) { int($a / 3) }, clone(\@monkeys)->@*);
