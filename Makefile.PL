
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
    "bin/novel_chapter_to_json.pl",
    "bin/novel_index_to_json.pl",
    "bin/novel_query_to_json.pl",
    "bin/novel_to_any.pl",
    "bin/novel_to_html.pl",
    "bin/novel_to_txt.pl",
    "bin/novel_to_wordpress.pl",
    "bin/novel_writer_to_json.pl"
  ],
  "LICENSE" => "perl",
  "NAME" => "Novel::Robot",
  "PREREQ_PM" => {
    "Encode::Locale" => "1.03",
    "JSON" => "2.53",
    "Moo" => "1.000007",
    "Novel::Robot::Browser" => "0.04",
    "Novel::Robot::Packer" => "0.01",
    "Novel::Robot::Parser" => "0.04",
    "Term::Menus" => "2.21",
    "WordPress::XMLRPC" => "1.23"
  },
  "VERSION" => "0.11",
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



