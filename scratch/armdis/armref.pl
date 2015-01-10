#! /usr/bin/perl
## -*- mode: cperl; compile-command: "perl armref.pl armref.txt" -*-
##
use strict;
use warnings;

sub code {
	my ($pos, $code, $bits) = @_;
	$bits = 1 unless defined $bits;
	print "($pos $code $bits) ";
	return $bits;
}

while (<>)
{
	my ($txt, $def) = split (" cond ");
	unless ($txt =~ '^Opcode') {
		my @bits = split (" ", $def);
		print "(";
		my $n = 27;
		while (@bits > 0) {
			my $bit = shift @bits;
			if ($bit eq '0' || $bit eq '1' || $bit eq 'x' || $bit eq 'S' ||
					$bit eq 'P' || $bit eq 'U' || $bit eq 'I' || $bit eq 'N' || $bit eq 'W') {
				code ($n, $bit);
				$n--;
				next;
			} elsif ($bit eq 'Rn' || $bit eq 'Rd' || $bit eq 'Rs' || $bit eq 'Rm' ||
							 $bit eq 'field_mask' || $bit eq 'addr_mode' || $bit eq 'rotate' ||
							 $bit eq 'RdHi' || $bit eq 'RdLo' || $bit eq 'SBO' ||
							 $bit eq 'CRn' || $bit eq 'CRm' || $bit eq 'CRd' ||
							 $bit eq 'cp_num') {
				print "($n $bit) ";
				$n -= 4;
			} elsif ($bit eq 'SBZ') {
				print "($n $bit) ";
				if ($n == 21) {
					$n -= 2;
				} elsif (@bits == 0) {
					if ($n == 11) {
						$n -= 12;
					} else {
						die "Unknown SBZ at bit $n";
					}
				} elsif ($n == 19 || $n == 15 || $n == 11 && $bits[0] eq '1') {
					$n -= 4;
				} elsif ($n == 11 && $bits[0] eq '0') {
					$n -= 7;
				} else {
					die "Unknown SBZ at bit $n";
				}
			} elsif ($bit eq 'shift') {
				if ($n == 11) {
					$bit .= shift @bits;
					print "($n $bit) ";
					$n -= 5;
				} elsif ($n == 6) {
					print "($n $bit) ";
					$n -= 2;
				} else {
					die "Unknown shift at bit $n";
				}
			} elsif ($bit eq '#') {
				if ($n == 11 || $n == 7) {
					print "($n $bit) ";
					$n = -1;
				} else {
					die "Unknown # at bit $n";
				}
			} elsif ($n == 23 && ($bit eq '24_bit_offset' || $bit eq 'swi_number')) {
				print "($n $bit) ";
				$n = -1;
			} elsif ($bit eq 'register' && $bits[0] eq 'list') {
				$bit .= '_' . shift @bits;
				print "($n $bit) ";
				if ($n == 15 || $n == 14) {
					$n = -1;
				} else {
					die "Unkown $bit at $n";
				}
			} elsif ($bit eq 'op1') {
				if ($bits[0] eq '0' || $bits[0] eq '1') {
					$n -= code ($n, $bit, 3);
				} else {
					$n -= code ($n, $bit, 4);
				}
			} elsif ($bit eq 'op2') {
				$n -= code ($n, $bit, 4);
			} else {
				die "Unknown code $bit at bit $n";
			}
		}
		print "\"$txt\")@bits\n";
	}
}

