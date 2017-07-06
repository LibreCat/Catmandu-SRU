use strict;
use warnings;
use utf8;
use Test::More;
use Test::Exception;
use Catmandu::Importer::SRU;
use Catmandu::Importer::SRU::Parser::marcxml;
use lib ".";
require 't/lib/MockFurl.pm';

my %attrs = (
    base         => 'http://www.unicat.be/sru',
    query        => 'marcxml_ns_prefix.xml',
    recordSchema => 'marcxml',
    parser       => 'marcxml',
    furl         => MockFurl->new,
);

my $importer = Catmandu::Importer::SRU->new(%attrs);
my $records  = $importer->to_array();

is scalar @{$records}, 5, 'marc has 5 records';

ok exists $records->[0]->{_id},    'marc has _id';
ok exists $records->[0]->{record}, 'marc has record';
is_deeply $records->[0]->{record}->[0],
    [ 'LDR', ' ', ' ', '_', '00000ndd a2200000 u 4500' ], 'marc has leader';
is_deeply $records->[0]->{record}->[1],
    [ '001', ' ', ' ', '_', '004641415' ], 'marc has controlfield';
is_deeply $records->[0]->{record}->[-1],
    [
    '852',
    ' ',
    ' ',
    'a',
    'D-B',
    'c',
    'Mus.ms.autogr. Zelter, K. F. 17 (3)',
    'e',
    'Staatsbibliothek zu Berlin - Preußischer Kulturbesitz, Musikabteilung',
    'x',
    '30000655'
    ],
    'marc has datafield';

done_testing;
