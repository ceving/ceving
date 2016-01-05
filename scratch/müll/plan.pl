#! /usr/bin/perl -T
use strict;
use warnings;
use Data::Dumper;
use iCal::Parser;

my $y = int($ARGV[0]);

sub output
{
  print @_;
}

sub execute
{
  foreach (@_) { &$_(); }
}

sub element
{
  foreach (@_) {
    my $name = $_;
    *::->{$name} = sub {
      my @args = @_;
      return sub {
        my @attr = grep { ref($_) eq 'HASH' } @args;
        my @body = grep { ref($_) eq 'CODE' } @args;
        output '<', $name;
        foreach my $a (@attr) {
          foreach (keys %$a) {
            output ' ', $_, '="', $a->{$_}, '"';
          }
        }
        output '>';
        execute (@body);
        output '</', $name, '>';
      };
    };
  }
}

element (qw(HTML HEAD META TITLE BODY STYLE H1 H2 H3 H4 H5 H6 DL DT DD TABLE
TBODY TR TH TD P));

sub TEXT
{
  my @text = @_;
  return sub { output @text; }
}

my $title = TEXT("Müllplan $y");

sub html5
{
  output
      '<?xml version="1.0" encoding="utf-8"?>', "\n",
      '<!DOCTYPE html>', "\n";
  execute (@_);
  output "\n";
}

my $ics = iCal::Parser->new()->parse("$y.ics");

my %events;

my @M = (qw(Januar Februar März April Mai Juni Juli August September
Oktober November Dezember));

while (my ($m, $month) = each %{$ics->{'events'}->{$y}})
{
  while (my ($d, $day) = each %$month)
  {
    foreach my $event (values(%$day))
    {
      if ($event->{SUMMARY} =~ /(Blau|Grau)e Tonne/i) {
        $events{sprintf("%04d%02d%02d", $y, $m, $d)} =
            [sprintf("%2d. %s", $d, $M[$m-1]), $1];
      }
    }
  }
}

my $grau = TEXT('Grau');
my $blau = TEXT('Blau');

my $mieter;

{
  my @N = (qw(Gelezun Ziemann Lind));
  my $i = 0;
  $mieter = sub { return $N[$i++ % 3] };
}

sub rows
{
  my @rows = ();

  foreach (sort keys %events)
  {
    my ($date, $color) = @{$events{$_}};
    my ($r2, $r3);
    if ($color =~ /Grau/i) {
      ($r2, $r3) = (TD($grau), TD());
    }
    elsif ($color =~ /Blau/i) {
      ($r2, $r3) = (TD(), TD($blau));
    }
    else {
      die "Unknown color '$color'";
    }
    push @rows, TR(TD(TEXT($date), $r2, $r3, TD(TEXT(&$mieter)), TD({class=>'comment'})));
  }
  return @rows;
}

my $style = '
table {
  border-collapse: collapse;
}
table, th, td {
  border: 1pt solid black;
}
th, td {
  padding: 0 1em;
}
th:first-child, td:first-child {
  text-align: right;
}
td.comment {
  width: 15em;
}
';

html5 HTML(
  HEAD(
    META({charset=>'utf-8'}),
    TITLE($title)),
  BODY(
    STYLE({type=>'text/css'}, TEXT($style)),
    H1($title),
    TABLE(
      TBODY(
        TR(TH(TEXT('Datum')),
           TH({colspan=>2}, TEXT('Tonne')),
           TH(TEXT('Mieter')),
           TH(TEXT('Bemerkung'))),
        rows))));

