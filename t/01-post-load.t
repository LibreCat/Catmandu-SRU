#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Exception;

my $pkg;
BEGIN {
  $pkg = 'Catmandu::Importer::SRU';
  use_ok($pkg);
}
require_ok($pkg);

my %attrs = (
  base => 'http://www.unicat.be/sru',
  query => 'dna',
  recordSchema => 'marcxml',
  parser => 'marcxml' ,
);

my $importer = Catmandu::Importer::SRU->new(%attrs);

isa_ok($importer, $pkg);

can_ok($importer, 'each');

ok (my $obj = $importer->first , 'parse marc');

ok (exists $obj->{_id} , 'marc has _id');

ok (exists $obj->{record} , 'marc as record');

done_testing 7;
