use strict;
use Test::More;
use Catmandu::Importer::SRU;

require 't/lib/MockFurl.pm';

my %options = (
    base   => 'http://example.org/',
    query  => 'meta.xml',
    furl   => MockFurl->new,
    parser => 'meta',
);

ok my $importer = Catmandu::Importer::SRU->new(%options);
ok my $record   = $importer->first;
ok($record->{'version'} eq '1.1',            'version');
ok($record->{'numberOfRecords'} eq '23',     'numberOfRecords');
ok($record->{'resultSetId'} eq '1',          'resultSetId');
ok($record->{'resultSetIdleTime'} eq '5000', 'resultSetIdleTime');
ok($record->{'nextRecordPosition'} eq '11',  'nextRecordPosition');
ok($record->{'echoedSearchRetrieveRequest'}->{'version'} eq '1.1',
    'echoedSearchRetrieveRequest version');
ok(
    $record->{'echoedSearchRetrieveRequest'}->{'query'} eq
        'tit=soil and biology',
    'echoedSearchRetrieveRequest query'
);
ok($record->{'echoedSearchRetrieveRequest'}->{'xQuery'} eq '',
    'echoedSearchRetrieveRequest xquery');
ok(
    $record->{'echoedSearchRetrieveRequest'}->{'recordSchema'} eq
        'MARC21-xml',
    'echoedSearchRetrieveRequest recordSchema'
);
ok(
    $record->{'extraResponseData'}->{'accountOf'} eq
        'Zeitschriftendatenbank (ZDB)',
    'extraResponseData accountOf'
);
ok($record->{'extraResponseData'}->{'test:test'} eq 'test',
    'extraResponseData test');

done_testing;
