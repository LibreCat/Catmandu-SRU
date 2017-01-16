requires 'perl', 'v5.10.1';

on 'test', sub {
  requires 'Test::Simple', '1.001003';  # Core
  requires 'Test::More', '1.001003';    # Core
  requires 'Test::Exception';
  requires 'Test::Pod';
  requires 'XML::XPath', '1.13';
};

requires 'Catmandu', '0.9204';
requires 'YAML::XS', '0.34';    # implied by Catmandu
requires 'Moo', '1.005000';     # implied by Catmandu

requires 'Furl', '0.41';
requires 'XML::Struct', '0.16';
requires 'XML::LibXML::Simple', '0.91';
requires 'URI::Escape' , '1.60';

