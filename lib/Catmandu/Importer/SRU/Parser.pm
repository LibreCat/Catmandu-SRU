package Catmandu::Importer::SRU::Parser;

use Moo;
use XML::LibXML;

sub parse {
	my ($self,$record) = @_;

	return unless defined $record;

	if ($record->{recordPacking} eq 'xml' && $record->{recordSchema} eq 'info:srw/schema/1/marcxml-v1.1') {
		return $self->parse_marcxml($record->{recordData});
	}
	elsif ($record->{recordPacking} eq 'xml' && $record->{recordSchema} eq 'info:srw/schema/1/dc-schema') {
		return $self->parse_dc($record->{recordData});
	}
	else {
		return $record;
	}
}

sub parse_dc {
	my ($self, $xml) = @_;
    my $parser = XML::LibXML->new();
  	my $doc    = $parser->parse_string($xml);
    my $root   = $doc->documentElement;
    my $xc     = XML::LibXML::XPathContext->new( $root );

    my $record = {};

	for ($xc->findnodes('/*/*')) {
		my $name  = $_->nodeName;
		my $value = $_->textContent // '';
		push @{$record->{$name}} , $value;
	}

	return $record;
}

sub parse_marcxml {
	my ($self, $xml) = @_;
	my $parser = XML::LibXML->new();
  	my $doc    = $parser->parse_string($xml);
    my $root   = $doc->documentElement;
    my $xc     = XML::LibXML::XPathContext->new( $root );
  	$xc->registerNs("marc","http://www.loc.gov/MARC21/slim");
  
  	my @out;

  	my $id = undef;

  	for ($xc->findnodes('/marc:record/*')) {
  		my $name  = $_->nodeName;
  		my $value = $_->textContent // '';

  		if ($name eq 'leader') {
  			push @out , ['LDR' , ' ', ' ' , '_' , $value];
  		}
  		elsif ($name eq 'controlfield') {
  			my $tag = $xc->findvalue('@tag',$_);
  			push @out , [$tag ,  ' ', ' ' , '_' , $value];
  			$id = $value if $tag eq '001';
  		}
  		elsif ($name eq 'datafield') {
  			my $tag  = $xc->findvalue('@tag',$_);
  			my $ind1 = $xc->findvalue('@ind1',$_) // ' ';
  			my $ind2 = $xc->findvalue('@ind2',$_) // ' ';
  			my @subfield = ();
  			for ($xc->findnodes('.//marc:subfield',$_)) {
  				my $code  = $xc->findvalue('@code',$_);
  				my $value = $_->textContent;
  				push @subfield , $code;
  				push @subfield , $value;
  			}

  			push @out , [$tag ,  $ind1 , $ind2 , '_' , '' , @subfield];
  		}
  	}

  	return { _id => $id , record => \@out };
}

=head1 NAME

  Catmandu::Importer::SRU::Parser - Package transforms SRU responses into Perl 

=head1 SYNOPSIS

  package MyParser;

  use Moo;

  sub parse {
	my ($self,$record) = @_;
	my $schema  = $record->{recordSchema};
	my $packing = $record->{recordPacking};
	my $data    = $record->{recordData};

	... do some magic...

	return $perl_hash;
  }

=head1 DESCRIPTION

Catmandu::Importer::SRU can optionally include a parser to transform the returned records from SRU requests.
Any such parser needs to implement one instance method 'parse' which receives an SRU-record and returns a perl hash;

The default Catmandu::Importer::SRU::Parser parser will transform DC responses into an hash of arrays as in:

 { 
   'title' => [ 'title1' , 'title2' , ... ] ,
   'identifier' => [ 'id1' , 'id2' , ...]
 }

Each MARCXML response will be transformed into an format as defined by L<Catmandu::Importer::MARC>

=head1 AUTHOR

Patrick Hochstenbach, C<< <patrick.hochstenbach at ugent.be> >>

=cut

1;