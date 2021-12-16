#!/usr/bin/env perl

##
## Author......: See docs/credits.txt
## License.....: MIT
##

use strict;
use warnings;

sub module_constraints { [[0, 256], [-1, -1], [-1, -1], [-1, -1], [-1, -1]] }

sub module_generate_hash
{
  my $word      = shift;

  my $sum = 0;
  my $code1 = 0;
  my $code2 = 0;

  foreach $char (split //, $word) {
    my $letterCode = ord($char) - ord('a') + 22;
    $sum = ($sum + $letterCode) % (1 << 32);
    $code1 = ($code1 + ($letterCode << 11)) % (1 << 32);
    $code1 = (($code1 >> 17) + ($code1 << 4)) % (1 << 32);
    $code2 = (($code2 >> 29) + ($code2 << 3) + $letterCode * $letterCode) % (1 << 32);
  }

  my $h1 = (($code1 >> 11) + ($sum << 21)) % (1 << 32);
  my $h2 = $code2;

  my $hash = sprintf ('%08x:%08x', $h1, $h2);

  return $hash;
}

sub module_verify_hash
{
  my $line = shift;

  my ($h1, $h2, $word) = split (':', $line);

  return unless defined $h1;
  return unless defined $h2;
  return unless defined $word;

  $word = pack_if_HEX_notation ($word);

  my $new_hash = module_generate_hash ($word);

  return ($new_hash, $word);
}

1;
