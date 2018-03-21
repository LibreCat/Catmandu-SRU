use strict;
use Test::More;

use Catmandu::Importer::SRU;
require 't/lib/MockFurl.pm';

my %options = (
    base   => 'http://example.org/',
    query  => 'picaxml.xml',
    furl   => MockFurl->new,
    parser => 'picaxml',
);

ok my $importer = Catmandu::Importer::SRU->new(%options);
ok my $record = $importer->next;

is $record->{_id}, '00903482X', 'PPN';
is_deeply ['002@', undef, '0', 'Tw'], $record->{record}->[5], 'fields';

done_testing;
