use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::HTTP::LocalServer;

my $pkg;

BEGIN {
    $pkg = 'Catmandu::Fix::search_sru';
    use_ok $pkg;
}

require_ok $pkg;

{
    my $server
        = Test::HTTP::LocalServer->spawn( file => 't/files/sru_oai_dc.xml' );
    my $lookup = $pkg->new( 'key', $server->url )->fix( { key => 'value' } );
    ok defined $lookup->{key}, 'default parser';
    is scalar @{ $lookup->{key} }, 2, 'got records';
    $lookup = $pkg->new( 'nested.key', $server->url )->fix( { nested => { key => 'value' }} );
    is scalar @{ $lookup->{nested}->{key} }, 2, 'nested path';
    $lookup = $pkg->new( 'key.*', $server->url )->fix( { key => ['foo', 'bar'] } );
    ok defined $lookup->{key}->[0]->[0], 'array path'; 
    $server->stop;

}

{
    my $server = Test::HTTP::LocalServer->spawn( file => 't/files/21.xml' );
    my $lookup = $pkg->new( 'key', $server->url, parser => 'marcxml' )
        ->fix( { key => 'value' } );
    ok defined $lookup->{key}, 'marcxml parser';
    $lookup = $pkg->new(
        'key', $server->url,
        parser => 'marcxml',
        fixes  => 'marc_map(245a,dc_title);remove_field(record);'
    )->fix( { key => 'value' } );
    is scalar @{ $lookup->{key} }, 3, 'got fixed records';
    is $lookup->{key}->[0]->{dc_title}, 'Pedobiologia', 'got fixed value';
    $server->stop;

}

done_testing;