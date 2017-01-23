use strict;
use Test::More;

use Catmandu::Importer::SRU;
require 't/lib/MockFurl.pm';

my %options = (
    base   => 'http://example.org/',
    query  => 'sru_oai_dc.xml',
    furl   => MockFurl->new,
    parser => 'simple',
);

my $record = {
    'dc' => {
      'contributor' => [
        'Alice',
        'Bob'
      ],
      'date' => {
        'content' => '2013',
        'xmlns:srw_dc' => 'info:srw/schema/1/dc-schema'
      },
      'title' => 'Sample Title',
      'xmlns:dc' => 'http://purl.org/dc/elements/1.1/',
      'xmlns:oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/'
    }
};

is_deeply(
    Catmandu::Importer::SRU->new(%options)->first->{recordData}, $record,
    'parser=simple'
);

delete $options{parser};
is_deeply(
    Catmandu::Importer::SRU->new(%options)->first->{recordData}, $record,
    'simple as default option'
);

done_testing;
