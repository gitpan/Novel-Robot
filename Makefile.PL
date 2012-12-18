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
        'Encode' => 0,
        'Encode::Detect::CJK' => 0,
        'HTML::TableExtract' => 0,
        'HTTP::Tiny' => 0,
        'IO::Uncompress::Gunzip' => 0,
        'Moo' => 0,
        'Web::Scraper' => 0,
        'Encode::Locale'=> 0, 
        'Getopt::Std' => 0, 
        'HTML::FormatText' => 0,
        'HTML::TreeBuilder' => 0,
        'JSON' => 0,
        'Term::Menus' => 0,
        'WordPress::XMLRPC' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Novel-Robot-*' },
);
