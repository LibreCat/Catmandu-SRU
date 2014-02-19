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

$options{recordTag} = 'dc';

is(Catmandu::Importer::SRU->new(%options)->each(sub { 
    like $_[0]->{title}, qr/ Title/, 'got record';
}), 2);

done_testing;

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
