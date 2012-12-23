#!/usr/bin/perl 
#===============================================================================
#  DESCRIPTION: 小说目录页信息，以JSON显示
#       AUTHOR: Abby Pan (abbypan@gmail.com), USTC 
#===============================================================================

use strict;
use warnings;
use utf8;
use JSON;



use Novel::Robot;

my ($index_url) = @ARGV;

my $xs = Novel::Robot->new();
my $index_ref = $xs->get_index_ref($index_url);
exit unless($index_ref);

my $index_json = encode_json $index_ref;
print $index_json;
