#! /usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Parse::RecDescent;
use Encode qw(decode_utf8);

sub debug_str {
    for (@_) {
        print STDERR Encode::is_utf8($_) ? 'UTF-8' : 'BINARY', ': ', Dumper ($_);
    }
}

sub debug { print STDERR "### ", Dumper(@_), "\n" }

my $eql = q{
  start: <skip: '[ \t]*'>
    select select_list from table_reference
    {{select => $item{select_list}, from => $item{table_reference}}}

  select_list: '*' | column_reference_list
  column_reference_list: column_reference ( ',' column_reference )(s?) {[$item[1]]}
  column_reference: identifier

  table_reference: identifier

  identifier:  regular_identifier | quoted_identifier

  select: /select/i
  from: /from/i

  regular_identifier: /[a-z][a-z0-9]*/i {$item[1]}
  quoted_identifier: /"[^\"]+"/i {$item[1]}

};

$::RD_ERRORS = 1;
$::RD_WARN = 1;
$::RD_HINT = 1;
#$::RD_TRACE = 1;

my $parser = Parse::RecDescent->new($eql) || die "Bad grammar";

my $query = $parser->start('select firstname from person'); 
die "No match" unless defined $query;

print Dumper $query;
