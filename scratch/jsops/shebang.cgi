#! /bin/bash
export NYTPROF=trace=2:start=init:file=/tmp/nytprof.out
#! -*-perl-*-
eval 'exec perl -d:NYTProf -x/tmp $0 ${1+"$@"}'
    if 0;

print "hello world\n";
