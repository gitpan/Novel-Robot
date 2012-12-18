#!/usr/bin/perl 
#===============================================================================
#  DESCRIPTION: 查询返回的信息，以JSON显示
#       AUTHOR: Abby Pan (abbypan@gmail.com), USTC 
#===============================================================================

use strict;
use warnings;
use utf8;
use JSON;



use Novel::Robot;

use Encode::Locale;
use Encode;


my ($site,$keyword,$value) = @ARGV;
$keyword = decode( locale => $keyword);
$value = decode( locale => $value);


my $xs = Novel::Robot->new();
$xs->set_site($site);
my $query_ref = $xs->get_query_ref($keyword, $value);
exit unless($query_ref);

my $query_json = encode_json $query_ref;
print $query_json;
