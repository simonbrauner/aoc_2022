#!/usr/bin/env perl

use v5.36;


my @packets;

my $file_content = join '', <>;
while ($file_content =~ /([^\n]*)\n([^\n]*)\n\n?/g) {
    push @packets, { left => $1, right => $2 };
}
