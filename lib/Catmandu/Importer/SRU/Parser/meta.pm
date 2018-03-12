
=head1 NAME

  Catmandu::Importer::SRU::Parser::meta - Package transforms SRU responses metadata into a Perl hash

=head1 SYNOPSIS

my %attrs = (
    base => 'http://www.unicat.be/sru',
    query => 'tit=cinema',
    recordSchema => 'marcxml' ,
    parser => 'meta' ,
);

my $importer = Catmandu::Importer::SRU->new(%attrs);

=head1 DESCRIPTION

Transforms SRU set metadata into a Perl hash containing the fields described by 
L<SRU SearchRetrieve Response Parameters|http://www.loc.gov/standards/sru/sru-1-1.html#responseparameters>
like:

    * version - The version of the response.
    * numberOfRecords - The number of records matched by the query. If the query fails this will be 0.
    * resultSetId - The identifier for a result set that was created through the execution of the query.
    * resultSetIdleTime - The number of seconds after which the created result set will be deleted.
    * nextRecordPosition - The next position within the result set following the final returned record. If there are no remaining records, this field should be omitted.
    * extraResponseData - Additional, profile specific information.
    * The request parameters echoed back to the client.

=head1 AUTHOR

Carsten Klee C<< <klee at cpan.org> >>

=cut

package Catmandu::Importer::SRU::Parser::meta;

use Moo;

sub parse {
    return $_[1];
}

1;
