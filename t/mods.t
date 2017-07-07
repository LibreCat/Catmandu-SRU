use strict;
use warnings;
use utf8;
use Test::More;
use Catmandu::Importer::SRU;
use Catmandu::Importer::SRU::Parser::mods;
use lib ".";
require 't/lib/MockFurl.pm';

my %attrs = (
    base         => 'http://www.unicat.be/sru',
    query        => 'mods.xml',
    recordSchema => 'mods',
    parser       => 'mods',
    furl         => MockFurl->new,
);

my $importer = Catmandu::Importer::SRU->new(%attrs);
my $records  = $importer->to_array();

is scalar @{$records}, 5, 'mods has 5 records';
is $records->[0]->{_id}, 'http://kalliope-verbund.info/DE-611-BF-18449',
    'mods has _id';
ok exists $records->[0]->{record}, 'mods has record';
is_deeply $records->[0]->{record}->{identifier},
    [
    {   _body => "http://kalliope-verbund.info/DE-611-BF-18449",
        type  => "uri"
    }
    ],
    'mods has record key';
is_deeply $records->[0]->{record}->{name}->[0]->{namePart},
    [
    {   _body => "Löwenstein, Hubertus zu (1906-1984)"
    }
    ],
    'check encoding';

done_testing;
