package Catmandu::Importer::SRU;

use Catmandu::Sane;
use URI::Escape;
use Moo;
use Furl;
use XML::Struct;

with 'Catmandu::Importer';

# required.
has base => (is => 'ro', required => 1);
has query => (is => 'ro', required => 1);
has version => (is => 'ro', default => sub { '1.1' });
has operation => (is => 'ro', default => sub { 'searchRetrieve' });
has recordSchema => (is => 'ro', default => sub { 'dc' });
has userAgent => (is => 'ro', default => sub { 'Mozilla/5.0' });
has furl => (is => 'ro', lazy => 1, builder => sub {
    Furl->new( agent => $_[0]->userAgent );
});

# optional.
has sortKeys => (is => 'ro');
has recordTag => (is => 'ro');
has xml => (is => 'ro', default => sub { 'simple' });

# internal stuff.
has _currentRecordSet => (is => 'ro');
has _n => (is => 'ro', default => sub { 0 });
has _start => (is => 'ro', default => sub { 1 });
has _max_results => (is => 'ro', default => sub { 10 });

# Internal Methods. ------------------------------------------------------------

# Internal: HTTP GET something.
#
# $url - the url.
#
# Returns the raw response object.
sub _request {
  my ($self, $url) = @_;

  my $res = $self->furl->get($url);
  die $res->status_line unless $res->is_success;

  return $res;
}

# Internal: Converts XML to a perl hash.
#
# $in - the raw XML input.
#
# Returns a hash representation of the given XML.
sub _hashify {
  my ($self, $in) = @_;

  my $out = XML::Struct::readXML( $in, ns => 'strip' );
  
  if ($self->xml eq 'struct') {
    $out = XML::Struct::simpleXML( $out, depth => 2 );
  } else { 
    $out = XML::Struct::simpleXML( $out );
  }

  return $out;
}

# Internal: Makes a call to the SRU API.
#
# Returns the XML response body.
sub _api_call {
  my ($self) = @_;

  # construct the url
  my $url = $self->base;
  $url .= '?version=' . uri_escape($self->version);
  $url .= '&operation=' .uri_escape($self->operation);
  $url .= '&query=' . uri_escape($self->query);
  $url .= '&recordSchema=' . uri_escape($self->recordSchema);
  $url .= '&sortKeys=' . uri_esacpe($self->sortKeys) if $self->sortKeys;
  $url .= '&startRecord=' . uri_escape($self->_start);
  $url .= '&maximumRecords=' . uri_escape($self->_max_results);

  # http get the url.
  my $res = $self->_request($url);

  # return the response body.
  return $res->{content};
}

# Internal: gets the next set of results.
#
# Returns a array representation of the resultset.
sub _nextRecordSet {
  my ($self) = @_;

  # fetch the xml response and hashify it.
  my $xml = $self->_api_call;
  my $hash = $self->_hashify($xml);

  # sru specific error checking.
  if (my $error = $hash->{'diagnostics'}->{'diagnostic'}) {
    warn 'SRU DIAGNOSTIC: ', $error->{'message'};
  }

  # get to the point.
  my $set = $hash->{'records'}->{'record'};

  # return a reference to a array.
  return \@{$set};
}

# Internal: gets the next record from our current resultset.
#
# Returns a hash representation of the next record.
sub _nextRecord {
  my ($self) = @_;

  # fetch recordset if we don't have one yet.
  $self->{_currentRecordSet} = $self->_nextRecordSet unless $self->_currentRecordSet;

  # check for a exhaused recordset.
  if ($self->_n >= $self->_max_results) {
	  $self->{_currentRecordSet} = $self->_nextRecordSet;
	  $self->{_start} += $self->_max_results;
	  $self->{_n} = 0;
  }

  # return the next record.
  my $record = $self->_currentRecordSet->[$self->{_n}++];

  if ($self->xml eq 'struct') {
    $record = $record->{recordData}->[0]->[2];
    if ($self->recordTag) {
      $record = $record->[0];
    }
  } else {
    if ($self->recordTag) {
      $record = $record->{recordData}->{$self->recordTag};
    }
  }

  return $record;
}

# Public Methods. --------------------------------------------------------------

sub generator {
  my ($self) = @_;

  return sub {
    $self->_nextRecord;
  };
}

=head1 NAME

  Catmandu::Importer::SRU - Package that imports SRU data

=head1 SYNOPSIS

  use Catmandu::Importer::SRU;

  my %attrs = (
    base => 'http://www.unicat.be/sru',
    query => '(isbn=0855275103 or isbn=3110035170 or isbn=9010017362 or isbn=9014026188)'
  );

  my $importer = Catmandu::Importer::SRU->new(%attrs);

  my $n = $importer->each(sub {
    my $hashref = $_[0]->{recordData};
    # ...
  });

  my $importer = Catmandu::Importer::SRU->new(%attrs, xml => 'struct', recordTag => 1);
  my $record = $importer->first();

=head1 CONFIGURATION

=over

=item base

base URL of the SRU server (required)

=item query

CQL query (required)

=item recordSchema

set to C<dc> by default

=item sortkeys

optional sorting

=item recordTag

optional XML tag name to get record data from. If not given, each record in
simple XML format will contain a recordData field that contains another tag
that contains the actual record fields. For instance recordTag C<dc> will
return the field C<< $record->{recordData}->{dc} >> in simple XML. When option
C<xml> is set to C<struct>, the actual value of option C<recordTag> does not
matter.

=item xml

optional selection of XML encoding variant. Set to C<simple> for L<XML::Simple>
format by default. Use C<struct> to get order-preserving XML as used by
L<XML::Struct>. Each record will be either an array reference with record
root element(s), or the first record root element, if option C<recordTag> is 
enabled.

=item operation

set to C<searchRetrieve> by default

=item version

set to C<1.1> by default.

=item userAgent

HTTP user agent, set to C<Mozilla/5.0> by default.

=item furl

Instance of L<Furl> or compatible class to fetch URLs with.

=back

=head1 METHODS

All methods of L<Catmandu::Importer> and by this L<Catmandu::Iterable> are
inherited.

=head1 SEE ALSO

L<http://www.loc.gov/standards/sru/>

=cut

1;
