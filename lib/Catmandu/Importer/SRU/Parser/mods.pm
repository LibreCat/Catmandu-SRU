
=head1 NAME

  Catmandu::Importer::SRU::Parser::mods - Package imports SRU responses with MODS records

=head1 SYNOPSIS

my %attrs = (
    base => 'http://www.unicat.be/sru',
    query => '(isbn=0855275103 or isbn=3110035170 or isbn=9010017362 or isbn=9014026188)',
    recordSchema => 'mods' ,
    parser => 'mods' ,
);

my $importer = Catmandu::Importer::SRU->new(%attrs);

=head1 DESCRIPTION

Each MODS record of the SRU response will be transformed into a hash.

=head1 AUTHOR

Johann Rolschewski, C<< <jorol at cpan.org> >>

=cut

package Catmandu::Importer::SRU::Parser::mods;

use Carp qw<carp>;
use Catmandu::Importer::MODS;
use Cpanel::JSON::XS;

use Moo;

our $VERSION = '0.41';

sub parse {
    my ($self, $record) = @_;

    my $xml = $record->{recordData}->toString();

    my $importer = Catmandu::Importer::MODS->new(file => \$xml);
    my $mods = $importer->first;

    if (defined $mods) {
        my $id = $mods->get_identifier->{_body};
        my $mods_record
            = Cpanel::JSON::XS->new->utf8->decode($mods->as_json());
        return {_id => $id, record => $mods_record->{mods}};
    }
    return;
}

1;
