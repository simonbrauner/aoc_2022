#!/usr/bin/env perl

use v5.36;

use List::Util qw{sum min};


sub sizes_of_dirs($commands, $path) {
    my %directory_sizes;
    my $current_size = 0;

    while ($commands->@*) {
        my $command = shift $commands->@*;
        last if $command =~ /cd \.\./;

        if ($command =~ /cd (.+)/) {
            shift $commands->@*;

            my $new_path = $path . $1 . '/';
            my %new_dir = sizes_of_dirs($commands, $new_path);

            %directory_sizes = (%directory_sizes, %new_dir);
            $current_size += $new_dir{$new_path};
        } elsif ($command =~ /(\d+) .+/) {
            $current_size += $1;
        }
    }

    $directory_sizes{$path} = $current_size;

    return %directory_sizes;
}

sub sum_of_dirs(%dirs) {
    sum grep { $_ <= 100000 } values %dirs;
}

sub dir_to_delete(%dirs) {
    min grep { $dirs{'/'} - $_ <= 40000000 } values %dirs;
}

my @commands;

foreach my $line (<>) {
    chomp $line;

    push @commands, $line;
}

shift @commands for (1..2);
my %dirs = sizes_of_dirs(\@commands, '/');

say sum_of_dirs(%dirs);
say dir_to_delete(%dirs);
