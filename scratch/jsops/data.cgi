#! /usr/bin/perl

use strict;
use warnings;
use DBI;
use Data::Dumper;
use JSON;
use CGI;

my $cgi = CGI->new;

my $dbh = DBI->connect(
    "dbi:SQLite:dbname=data.sqlite3",
    "", # no user
    "", # no pw
    { RaiseError => 1,
      sqlite_unicode => 1 },
) || die $DBI::errstr;


my $sth = $dbh->prepare("SELECT * FROM person");
$sth->execute();

my $json = encode_json $sth->fetchall_arrayref({});

$sth->finish();
$dbh->disconnect();

print
    $cgi->header(-type=>'application/json',
                 -charset => 'UTF-8'),
    $json;
