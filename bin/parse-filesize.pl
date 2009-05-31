#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dump 'dump';
use feature ':5.10';

my $in_z12 = 0;
my $in_block = 1;
my $z12_buffer = '';

my ($biggest, $smallest);

while (<>) {
    # Skip up to the first z12 tileset
    unless ($in_z12) {
        next unless m[\./0000:$];
        $in_z12 = 1;
    }


    unless (/^$/) {
        $z12_buffer .= $_;
    } else {
        parse_buffer($z12_buffer);
        $z12_buffer = '';
        next;
    }
}

say STDERR "Biggest, Smallest = $biggest, $smallest";

sub parse_buffer
{
    my $buffer = shift;
    my @lines = split /^/, $buffer;

    my $x_str = shift @lines;
    my ($x) = $x_str =~ m[^\./0*(\d+):];

    # shift total
    shift @lines;

    while (my $line = shift @lines)
    {
        chomp $line;
        my ($size, $name) = $line =~ /^\S+\s+\S+\s+\S+\s+\S+\s+(\d+)\s+\S+\s+\S+\s+\S+\s+(\S+)/;

        if ($name !~ /^\d+_\d+$/) {
            #warn "Danger $name";
            next;
        }

        if (not defined $biggest or $size > $biggest) {
            $biggest = $size;
        }
        if (not defined $smallest or $size < $smallest) {
            $smallest = $size;
        }

        my ($x, $y) = $name =~ /^(\d+)_(\d+)$/;
        $x = sprintf "%04d", $x;
        $y = sprintf "%04d", $y;

        say "$x,$y\t$size";
    }

    return;
}
