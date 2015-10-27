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

sub timestamp
{
    my $time = shift || time;

    my @days = qw(Sun Mon Tue Wed Thu Fri Sat);
    my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

    my ($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime($time);

    return sprintf ("%s, %02d %s %d %02d:%02d:%02d GMT",
                    $days[$wday], $mday, $months[$mon], $year+1900,
                    $hour, $min, $sec);
}

debug \%ENV;
debug $CFG;

#
# Must constraints
#
die "Gateway interface is not CGI/1.1"
    unless $ENV{GATEWAY_INTERFACE} =~ m{\bCGI/1.1\b}i;
die "Application is unknown"
    unless exists $CFG->{app}->{$ENV{QUERY_STRING}};
die "Request is neither GET nor POST" 
    unless $ENV{REQUEST_METHOD} eq 'GET' || $ENV{REQUEST_METHOD} eq 'POST';

#
# Should constraints
#
warn "Request is not encrypted"
    unless $ENV{REQUEST_SCHEME} eq 'HTTPS';
    
#
# Binary IO
#
binmode STDIN;
binmode STDOUT;

my $header;
my $body;

#
# Open database connection
#
my $db = $CFG->{app}->{$ENV{QUERY_STRING}}->{db};

die "Database driver undefined" unless exists $db->{driver};
die "Database name undefined" unless exists $db->{name};

my $dbh = DBI->connect (
    join (':', 'dbi', $db->{driver}, $db->{name}),
    undef, undef, {
        RaiseError => 1,
        sqlite_unicode => 1
    }) || die $DBI::errstr;
#$dbh->trace(2);

#
# Process GET request: deliver DAO objects.
#
if ($ENV{REQUEST_METHOD} eq 'GET')
{
    $body = q{function eql() { console.log("eql"); }};

    my $now = timestamp;
        
    $header = join ("\r\n",
                    "Content-length:" . length($body),
                    "Content-Type:application/javascript;charset=utf-8",
                    "Date:" . $now,
                    "Expires:" . $now,
                    "Cache-Control:max-age=0,no-cache,no-store",
                    "Pragma:no-cache",
                    "\r\n");
}

#
# Process POST request: modify data.
#
elsif ($ENV{REQUEST_METHOD} eq 'POST')
{
    #
    # Must constraints
    #
    die "Content is not UTF-8 encoded SQL"
        unless $ENV{CONTENT_TYPE} =~ m{application/sql;[ ]+charset=utf-8}i;
    die "Content length is not numeric"
        unless $ENV{CONTENT_LENGTH} =~ /^\d+$/;

    #
    # Read request
    #
    my $content;
    my $n = read (STDIN, $content, $ENV{CONTENT_LENGTH});

    die "Content length ($ENV{CONTENT_LENGTH}) differs from the number of bytes read ($n)"
        unless $n == $ENV{CONTENT_LENGTH};

    my $sql = decode_utf8 $content;

    #
    # Query database
    #
    my $sth = $dbh->prepare ($sql);
    $sth->execute();

    my $data = $sth->fetchall_arrayref ({});

    $sth->finish();

    #
    # Return response
    #
    my $now = timestamp;
    $body = encode_json $data;
    $header = join ("\r\n",
                    "Content-length:" . length($body),
                    "Content-Type:application/json;charset=utf-8",
                    "Date:" . $now,
                    "Expires:" . $now,
                    "Cache-Control:max-age=0,no-cache,no-store",
                    "Pragma:no-cache",
                    "\r\n");
}

#
# Disconnect database.
#
$dbh->disconnect ();

#
# Deliver response.
#
debug $header;
debug $body;

stdout $header, $body;

__DATA__

__END__
