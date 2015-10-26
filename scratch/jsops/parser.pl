#! /usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Parse::RecDescent;

my $eql = q{
  start: <skip: '[ \t\n]*'> query

  query:
    SELECT select_list FROM table_reference(s /,/) where_clause(?)
    {{select => $item[2],
      from => $item[4]}}

  select_list:
    '*' | column_reference(s /,/)

  column_reference:
    identifier(1..2 /\./)
    {{table=>$item[1][-2],
      column=>$item[1][-1]}}

  table_reference:
    identifier (AS identifier)(?)
    {{table=>$item[1],
      as=>$item[2][0]}}

  where_clause:
    WHERE boolean_value_expression

  boolean_value_expression:
    boolean_term ( OR boolean_value_expression )(?)

  boolean_term:
    boolean_factor ( AND boolean_term )(?)

  boolean_factor:
    NOT(?) boolean_test

  boolean_test:
    boolean_primary ( IS NOT(?) boolean_literal )(?)

  boolean_primary:
    predicate | boolean_predicand

  boolean_predicand:
    parenthesized_boolean_value_expression |
    nonparenthesized_value_expression_primary

  parenthesized_boolean_value_expression:
    '(' boolean_value_expression ')'

  nonparenthesized_value_expression_primary:
    unsigned_value_specification |
    column_reference

  unsigned_value_specification:
    unsigned_literal |
    general_value_specification

  unsigned_literal:
    unsigned_numeric_literal |
    general_literal

  unsigned_numeric_literal:
    exact_numeric_literal |
    approximate_numeric_literal

  exact_numeric_literal: {die "TODO"}

  approximate_numeric_literal: {die "TODO"}

  general_literal: 
    CHARACTER_STRING_LITERAL |
    BINARY_STRING_LITERAL |
    DATE DATE_STRING |
    TIME TIME_STRING |
    TIMESTAMP TIMESTAMP_STRING |
    interval_literal |
    boolean_literal

  interval_literal: {die "TODO"}

  boolean_literal:
    TRUE | FALSE | UNKNOWN

  general_value_specification: {die "TODO"}

  predicate: {die "TODO"}

  identifier:
    REGULAR_IDENTIFIER | QUOTED_IDENTIFIER

  AND: /and/i
  AS: /as/i
  DATE: /date/i
  FALSE: /false/i
  FROM: /from/i
  IS: /is/i
  NOT: /not/i
  OR: /or/i
  SELECT: /select/i
  TIME: /time/i
  TIMESTAMP: /timestamp/i
  TRUE: /true/i
  UNKNOWN: /unknown/i
  WHERE: /where/i

  REGULAR_IDENTIFIER: /[a-z][a-z0-9]*/i
  QUOTED_IDENTIFIER: /"[^\"]+"/
  CHARACTER_STRING_LITERAL: /'(?:[^']+|\'\')+'/
  BINARY_STRING_LITERAL: /X'(?:[0-9a-f]{2})+'/i
  DATE_STRING: /'[0-9]+-[0-9]+-[0-9]+'/
  TIME_STRING: /'[0-9]+:[0-9]+:[0-9]+'/
  TIMESTAMP_STRING: /'[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+:[0-9]+'/

};

$::RD_ERRORS = 1;
$::RD_WARN = 1;
$::RD_HINT = 1;
#$::RD_TRACE = 1;

my $parser = Parse::RecDescent->new($eql) || die "Bad grammar";

print Dumper $parser->start('select * from person') ||
    die "No match";

print Dumper $parser->start(q{
  select person.firstname,middlename,lastname
  from person as p1,address
}) || die "No match";
