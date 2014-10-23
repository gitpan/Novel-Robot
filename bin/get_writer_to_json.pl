#!/usr/bin/perl 
#===============================================================================
#  DESCRIPTION: ����ר��ҳ��Ϣ����JSON��ʾ
#       AUTHOR: Abby Pan (abbypan@gmail.com), USTC 
#===============================================================================

use strict;
use warnings;
use utf8;
use JSON;



use Novel::Robot;

my ($writer_url) = @ARGV;

my $xs = Novel::Robot->new();
my $writer_ref = $xs->get_writer_ref($writer_url);
exit unless($writer_ref);

my $writer_json = encode_json $writer_ref->{series};
print $writer_json;
