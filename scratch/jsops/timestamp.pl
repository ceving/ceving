#! /usr/bin/perl

use strict;
use warnings;

sub timestamp
{
    my $time = time;

    my @days = qw(Sun Mon Tue Wed Thu Fri Sat);
    my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

    my @stamps = ();

    for (@_ ? @_ : 0)
    {
        my $t = $time + $_;
        my ($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime($t);

        push @stamps, sprintf (
            "%s, %02d %s %d %02d:%02d:%02d GMT",
            $days[$wday], $mday, $months[$mon], $year+1900, $hour, $min, $sec);
    }
    return @stamps;
}

use Data::Dumper;

print Dumper 
    timestamp,
    timestamp (0, 1, 2);
