use strict;
use Test::More;

use Catmandu::Importer::SRU;

my %options = (
    base  => 'http://sru.gbv.de/isil',
    query => 'sru_oai_dc.xml',
    furl  => MockFurl->new,
);
is(Catmandu::Importer::SRU->new(%options)->each(sub { 
    like $_[0]->{recordData}->{dc}->{title}, qr/ Title/, 'got record';
}), 2);

is(Catmandu::Importer::SRU->new(%options, recordTag => 'dc')->each(sub { 
    like $_[0]->{title}, qr/ Title/, 'got record';
}), 2);

my $record = Catmandu::Importer::SRU->new(%options, recordTag => 'dc')->first;
ok $record->{date}, 'don\'t include recordData (simple, recordTag)';

$record = Catmandu::Importer::SRU->new(%options)->first;
is ref $record->{recordData}, 'HASH', 'include recordData (simple, !recordTag)';

$record = Catmandu::Importer::SRU->new(%options, xml => 'struct')->first;
is $record->[0]->[0], 'dc', 'record as array of elements (struct, !recordTag)';

$record = Catmandu::Importer::SRU->new(%options, xml => 'struct', recordTag => 1)->first;
is $record->[0], 'dc', 'record as element (struct, recordTag)';

done_testing;

# returns an XML document, given as query, from directory t/
package MockFurl;
use Moo;
use Furl::Response;

sub get {
    my ($self, $url) = @_;
    $url =~ /query=([^&]+)/;
    my $xml = do { local (@ARGV,$/) = "t/$1"; <> };
    Furl::Response->new(1,200,'Ok',{}, $xml);
}

1;
