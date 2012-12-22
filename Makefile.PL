use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Novel::Robot',
    AUTHOR           => q{Abby Pan <abbypan@gmail.com>},
    VERSION_FROM     => 'lib/Novel/Robot.pm',
    ABSTRACT_FROM    => 'lib/Novel/Robot.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    EXE_FILES => [
        'bin/get_books_to_any.pl',
        'bin/get_book_to_html.pl',
        'bin/get_book_to_txt.pl',
        'bin/get_book_to_wordpress.pl',
        'bin/get_chapter_to_json.pl',
        'bin/get_index_to_json.pl',
        'bin/get_query_to_json.pl',
        'bin/get_writer_to_json.pl',
    ],
    PREREQ_PM => {
        'HTML::TableExtract' => 2.11,
        'Moo' => 1.000007,
        'Web::Scraper' => 0.37,
        'Encode::Locale'=> 1.03, 
        'HTML::FormatText' => 2.10,
        'HTML::TreeBuilder' => 5.03,
        'JSON' => 2.53,
        'Term::Menus' => 2.21,
        'WordPress::XMLRPC' => 1.23,
        'Novel::Robot::Browser' => 0.01, 
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Novel-Robot-*' },
);
