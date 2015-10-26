#! /usr/bin/perl

use strict;
use warnings;
use SQL::Parser;
use Data::Dumper;

my $parser = SQL::Parser->new();

$parser->parse(q{
  SELECT p1.firstname
  FROM foo as p1
  WHERE firstname = 'nix' AND ( lastname LIKE 'A%' OR middlename = 'Peter' )
}) || die "No match";

print Dumper $parser->structure;

