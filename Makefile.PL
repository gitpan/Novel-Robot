
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
    "bin/novel_to_any.pl",
    "bin/novel_to_html.pl",
    "bin/novel_to_txt.pl",
    "bin/novel_to_wordpress.pl"
  ],
  "LICENSE" => "perl",
  "NAME" => "Novel::Robot",
  "PREREQ_PM" => {
    "Encode::Locale" => "1.03",
    "JSON" => "2.53",
    "Moo" => "1.000007",
    "Novel::Robot::Browser" => "0.06",
    "Novel::Robot::Packer" => "0.02",
    "Novel::Robot::Parser" => "0.05",
    "Term::Menus" => "2.21"
  },
  "VERSION" => "0.12",
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



