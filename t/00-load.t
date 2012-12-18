#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Novel::Robot' ) || print "Bail out!\n";
}

diag( "Testing Novel::Robot $Novel::Robot::VERSION, Perl $], $^X" );
