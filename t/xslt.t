use strict;
use Test::More;

use Catmandu::Importer::SRU;
require 't/lib/MockFurl.pm';

plan(skip_all => 'Catmandu::XML >= 0.15 required')
    unless eval { 
        require Catmandu::XML;
        require XML::LibXML;
        version->parse($Catmandu::XML::VERSION) >= version->parse("0.15")
    };

my %options = (
    base   => 'http://example.org/',
    query  => 'sru_oai_dc.xml',
    furl   => MockFurl->new,
    parser => 'raw',
);

foreach my $xslt (qw(text.xsl rootless.xsl)) {
    is(Catmandu::Importer::SRU->new(%options, xslt => "t/files/$xslt")
        ->first->{recordData}, 'Sample TitleAliceBob2013', $xslt);
}

$options{parser} = 'simple';
$options{xslt} = 't/files/transform.xsl';
is_deeply( Catmandu::Importer::SRU->new(%options)->first->{recordData}, { 
  r => { 
    c => [ 'Alice', 'Bob' ],
    d => '2013',
    t => 'Sample Title'
  }
},
'xslt');
 
done_testing;
