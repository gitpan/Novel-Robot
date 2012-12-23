
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "\345\260\217\350\257\264\344\270\213\350\275\275\345\231\250",
  "AUTHOR" => "abbypan <abbypan\@gmail.com>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Novel-Robot",
  "EXE_FILES" => [
    "bin/get_query_to_json.pl",
    "bin/get_book_to_html.pl",
    "bin/get_book_to_txt.pl",
    "bin/get_index_to_json.pl",
    "bin/get_book_to_wordpress.pl",
    "bin/get_books_to_any.pl",
    "bin/get_chapter_to_json.pl",
    "bin/get_writer_to_json.pl"
  ],
  "LICENSE" => "perl",
  "NAME" => "Novel::Robot",
  "PREREQ_PM" => {
    "Moo" => "1.000007",
    "Novel::Robot::Browser" => "0.02",
    "Novel::Robot::Parser" => "0.03"
  },
  "VERSION" => "0.07",
  "test" => {
    "TESTS" => ""
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



