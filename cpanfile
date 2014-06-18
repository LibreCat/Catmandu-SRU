requires 'perl', 'v5.10.1';

on 'test', sub {
  requires 'Test::Simple', '1.001003';
  requires 'Test::More', '1.001003';
  requires 'XML::XPath', '1.13';
};

requires 'Catmandu', '0.9204';
requires 'Furl', '0.41';
requires 'YAML::XS', '0.34';
requires 'XML::LibXML::Simple', '0.91';
requires 'XML::Struct', '0.16';
requires 'URI::Escape' , '1.60';
requires 'Moo', '1.005000';