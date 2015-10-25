#! /usr/bin/perl

BEGIN
{
    push @INC, '/home/szi/p/ceving/scratch/jsops';
}

use strict;
use warnings;
use DBI;
use Data::Dumper;
use JSON;
use CGI::Carp;
use Parse::RecDescent;
use Encode qw(decode_utf8);
use POSIX qw(strftime);
use CFG;

my $CFG = CFG->new('/etc/eql.cfg');

sub stdout { print STDOUT @_; }
sub stderr { print STDERR @_; }

sub debug_str {
    for (@_) {
        stderr Encode::is_utf8($_) ? 'UTF-8' : 'BINARY', ': ', Dumper ($_);
    }
}

sub debug { stderr Dumper(@_) }

debug \%ENV;
debug $CFG;

#
# Must constraints
#
die "Gateway interface is not CGI/1.1"
    unless $ENV{GATEWAY_INTERFACE} =~ m{\bCGI/1.1\b}i;
die "Request is not POST"
    unless $ENV{REQUEST_METHOD} eq 'POST';
die "Content is not UTF-8 encoded SQL"
    unless $ENV{CONTENT_TYPE} =~ m{application/sql;[ ]+charset=utf-8}i;
die "Requester does not accept JSON"
    unless $ENV{HTTP_ACCEPT} =~ m{\bapplication/json\b}i;
die "Content length is not numeric"
    unless $ENV{CONTENT_LENGTH} =~ /^\d+$/;
die "Database is unknown"
    unless exists $CFG->{db}->{$ENV{QUERY_STRING}};

#
# Should constraints
#
warn "Request is not encrypted"
    unless $ENV{REQUEST_SCHEME} eq 'HTTPS';

#
# Read request
#
binmode STDIN;
binmode STDOUT;

my $content;
my $n = read (STDIN, $content, $ENV{CONTENT_LENGTH});

die "Content length ($ENV{CONTENT_LENGTH}) differs from the number of bytes read ($n)"
    unless $n == $ENV{CONTENT_LENGTH};

my $sql = decode_utf8 $content;

#
# Query database
#
my $db = $CFG->{db}->{$ENV{QUERY_STRING}};

die "Database driver undefined" unless exists $db->{driver};
die "Database name undefined" unless exists $db->{name};

my $dbh = DBI->connect(
    join (':', 'dbi', $db->{driver}, $db->{name}),
    undef, undef, {
        RaiseError => 1,
        sqlite_unicode => 1
    },
) || die $DBI::errstr;
#$dbh->trace(2);

my $sth = $dbh->prepare($sql);
$sth->execute();

my $data = $sth->fetchall_arrayref({});

$sth->finish();
$dbh->disconnect();

#
# Return response
#

my $body = encode_json $data;

my @days = qw(Sun Mon Tue Wed Thu Fri Sat);
my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

my ($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime;
my $timestamp = sprintf (
    "%s, %02d %s %d %02d:%02d:%02d GMT",
    $days[$wday], $mday, $months[$mon], $year, $hour, $min, $sec);

my $header = join ("\r\n",
                   "Content-length:" . length($body),
                   "Content-Type:application/json;charset=utf-8",
                   "Date:" . $timestamp,
                   "Expires:" . $timestamp,
                   "Cache-Control:max-age=0,no-cache,no-store",
                   "Pragma:no-cache",
                   "\r\n");

debug $header;
debug $body;

stdout $header, $body;
