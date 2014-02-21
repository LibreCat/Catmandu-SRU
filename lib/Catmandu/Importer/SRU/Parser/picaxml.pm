package Catmandu::Importer::SRU::Parser::picaxml;
use Moo;
use XML::Struct qw(readXML);

sub parse {
    print $_[0] ."...\n";
#    my $record = $_[0]->{recordData};
#    print STDERR $record;
#    my $xml = readXML($record);
    die;
    return { };
}

1;
