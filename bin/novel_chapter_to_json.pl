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

my ($chapter_url, $id) = @ARGV;

my $xs = Novel::Robot->new();
my $chapter_ref = $xs->get_chapter_ref($chapter_url, $id);
exit unless($chapter_ref);

my $chapter_json = encode_json $chapter_ref;
print $chapter_json;
