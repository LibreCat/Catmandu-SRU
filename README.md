# NAME

Catmandu::SRU - Catmandu module for working with SRU data

# STATUS
[![Build Status](https://travis-ci.org/LibreCat/Catmandu-SRU.svg?branch=master)](https://travis-ci.org/LibreCat/Catmandu-SRU)
[![Coverage](https://coveralls.io/repos/LibreCat/Catmandu-SRU/badge.png?branch=master)](https://coveralls.io/r/LibreCat/Catmandu-SRU)
[![CPANTS kwalitee](http://cpants.cpanauthors.org/dist/Catmandu-SRU.png)](http://cpants.cpanauthors.org/dist/Catmandu-SRU)

# SYNOPSIS

    # On the command line
    $ catmandu convert SRU --base http://www.unicat.be/sru --query data

    $ catmandu convert SRU --base http://www.unicat.be/sru --query data --recordSchema marcxml

    $ catmandu convert SRU --base http://www.unicat.be/sru --query data --recordSchema marcxml --parser marcxml

    # create a config file: catmandu.yml
    $ cat catmandu.yml
    ---
    importer:
      unicat:
        package: SRU
        options:
           base: http://www.unicat.be/sru
           recordSchema: marcxml
           parser: marcxml

     $ catmandu convert unicat --query data

     # If you have Catmandu::MARC installed
     $ catmandu convert unicat --query data --fix 'marc_map("245a","title"); retain_field("title")' to CSV

     # The example above in perl
     use Catmandu -load;

     my $importer = Catmandu->importer('unicat', query => 'data');
     my $fixer    = Catmandu->fixer(['marc_map("245a","title")','retain_field("title")']);
     my $export   = Catmandu->exporter('CSV');

     $exporter->add_many($fixer->fix($importer));

     $exporter->commit;

# MODULES

- [Catmandu::Importer::SRU](https://metacpan.org/pod/Catmandu::Importer::SRU)
- [Catmandu::Importer::SRU::Parser](https://metacpan.org/pod/Catmandu::Importer::SRU::Parser)
- [Catmandu::Importer::SRU::Parser::raw](https://metacpan.org/pod/Catmandu::Importer::SRU::Parser::raw)
- [Catmandu::Importer::SRU::Parser::simple](https://metacpan.org/pod/Catmandu::Importer::SRU::Parser::simple)
- [Catmandu::Importer::SRU::Parser::struct](https://metacpan.org/pod/Catmandu::Importer::SRU::Parser::struct)
- [Catmandu::Importer::SRU::Parser::marcxml](https://metacpan.org/pod/Catmandu::Importer::SRU::Parser::marcxml)
- [Catmandu::Importer::SRU::Parser::meta](https://metacpan.org/pod/Catmandu::Importer::SRU::Parser::meta)
- [Catmandu::Importer::SRU::Parser::mods](https://metacpan.org/pod/Catmandu::Importer::SRU::Parser::mods)
- [Catmandu::Importer::SRU::Parser::picaxml](https://metacpan.org/pod/Catmandu::Importer::SRU::Parser::picaxml)
- [Catmandu::Fix::sru\_search](https://metacpan.org/pod/Catmandu::Fix::sru_search)

# SEE ALSO

[Catmandu](https://metacpan.org/pod/Catmandu),
[Catmandu::Importer](https://metacpan.org/pod/Catmandu::Importer),
[Catmandu::Fix](https://metacpan.org/pod/Catmandu::Fix),
[Catmandu::Exporter](https://metacpan.org/pod/Catmandu::Exporter),
[Catmandu::MARC](https://metacpan.org/pod/Catmandu::MARC)

# AUTHOR

Wouter Willaert, `<wouterw@inuits.eu>`

# CONTRIBUTORS

Patrick Hochstenbach, `<patrick.hochstenbach at ugent.be>`

Nicolas Steenlant, `<nicolas.steenlant at ugent.be>`

Jakob Voss `<jakob.voss at gbv.de>`

Johann Rolschewski `<jorol at cpan.org>`

# LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See [http://dev.perl.org/licenses/](http://dev.perl.org/licenses/) for more information.
