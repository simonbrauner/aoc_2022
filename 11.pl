#!/usr/bin/env perl

use v5.36;


my $file_content = join '', <>;
while ($file_content =~ /Monkey\s(\d+):\s+
                        Starting\sitems:\s(.*)\s+
                        Operation:\snew\s=\s(.*)\s+
                        Test:\sdivisible\sby\s(\d+)\s+
                        If\strue:\sthrow\sto\smonkey\s(\d+)\s+
                        If\sfalse:\sthrow\sto\smonkey\s(\d+)/gx) {
    say foreach @{^CAPTURE};
}
