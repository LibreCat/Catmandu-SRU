use strict;
use warnings;
use Test::More;
use Test::Exception;
use Catmandu::Importer::SRU;
use Catmandu::Importer::SRU::Parser::marcxml;

# FIXME: use MockFurl instead of live query
my %attrs = (
  base => 'http://www.unicat.be/sru',
  query => 'dna',
  recordSchema => 'marcxml',
);

my $importer = Catmandu::Importer::SRU->new(%attrs);

isa_ok($importer, 'Catmandu::Importer::SRU');

can_ok($importer, 'each');

my $marcparser = Catmandu::Importer::SRU::Parser::marcxml->new;
my @parsers = ( 
    'marcxml',
    '+Catmandu::Importer::SRU::Parser::marcxml',
    $marcparser,
    sub { $marcparser->parse($_[0]); }
);

foreach my $parser (@parsers) {
    my $importer = Catmandu::Importer::SRU->new(%attrs, parser => $parser);
    ok (my $obj = $importer->first , 'parse marc');
    ok (exists $obj->{_id} , 'marc has _id');
    ok (exists $obj->{record} , 'marc as record');
}

done_testing;
