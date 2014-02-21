package Catmandu::Importer::SRU::Parser::simple;
use strict;
use Moo;
use XML::LibXML::Simple ();

has xmlsimple => ( is => 'ro', default => sub { XML::LibXML::Simple->new } );

sub parse {
	my ($self, $record) = @_;

    $record->{recordData} = $self->xmlsimple->XMLin(
        $record->{recordData} , KeepRoot => 1, NsStrip => 1
    );

    $record;
}

=head1 NAME

Catmandu::Importer::SRU::Parser::simple - parse SRU records as simple XML

=head1 SYNOPSIS

This default record parser of L<Catmandu::Importer::SRU> transforms the SRU
response records field C<recordData> with L<XML::LibXML::Simple>. Namespaces
are stripped by default.

=head1 SEE ALSO

Use L<Catmandu::Importer::SRU::Parser::struct> for order-preserving or
mixed-content XML.

=head1 AUTHOR

Patrick Hochstenbach, C<< <patrick.hochstenbach at ugent.be> >>

Jakob Voß C<< voss@gbv.de >>

=encoding utf8

=cut

1;
