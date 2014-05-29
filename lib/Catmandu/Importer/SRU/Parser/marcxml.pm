=head1 NAME

  Catmandu::Importer::SRU::Parser::marcxml - Package transforms SRU responses into Catmandu MARC 

=head1 SYNOPSIS

my %attrs = (
    base => 'http://www.unicat.be/sru',
    query => '(isbn=0855275103 or isbn=3110035170 or isbn=9010017362 or isbn=9014026188)',
    recordSchema => 'marcxml' ,
    parser => 'marcxml' ,
);

my $importer = Catmandu::Importer::SRU->new(%attrs);

=head1 DESCRIPTION

Each MARCXML response will be transformed into an format as defined by L<Catmandu::Importer::MARC>

=head1 AUTHOR

Patrick Hochstenbach, C<< <patrick.hochstenbach at ugent.be> >>

=cut
package Catmandu::Importer::SRU::Parser::marcxml;

use Moo;
use XML::LibXML;

sub parse {
	my ($self,$record) = @_;

  my $xml = $record->{recordData};

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

1;
