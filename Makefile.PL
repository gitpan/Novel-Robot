
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
    "bin/novel_to_wordpress.pl",
    "bin/dzs_to_wordpress.pl",
    "bin/novel_to_txt.pl",
    "bin/novel_to_html.pl",
    "bin/novel_to_any.pl",
    "bin/dzs_to_html.pl"
  ],
  "LICENSE" => "perl",
  "NAME" => "Novel::Robot",
  "PREREQ_PM" => {
    "Encode::Locale" => 0,
    "JSON" => 0,
    "Moo" => 0,
    "Novel::Robot::Browser" => 0,
    "Novel::Robot::Packer" => 0,
    "Novel::Robot::Parser" => 0,
    "Parallel::ForkManager" => 0,
    "Term::Menus" => 0
  },
  "TEST_REQUIRES" => {},
  "VERSION" => "0.22",
  "test" => {
    "TESTS" => ""
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

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



