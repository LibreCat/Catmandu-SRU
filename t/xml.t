package MyParser;

use Moo;
use XML::Struct;

sub parse {
	my ($self,$in) = @_;

	my $out = XML::Struct::readXML( $in->{recordData}, ns => 'strip' );

	XML::Struct::simpleXML( $out );
}

package main;

use strict;
use Test::More;

use Catmandu::Importer::SRU;

my %options = (
    base  => 'http://sru.gbv.de/isil',
    query => 'sru_oai_dc.xml',
    furl  => MockFurl->new,
    parser => MyParser->new,
);

ok(my $i = Catmandu::Importer::SRU->new(%options));
ok(my $first = $i->first);
like($first->{title}, qr/ Title/, 'got record');

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
