#!/usr/bin/perl
use utf8;
use lib '../lib';
use Novel::Robot;
use Test::More ;
use Data::Dumper;
use utf8;

my $xs = Novel::Robot->new(site=> 'Jjwxc', type => 'wordpress');
my $index_url = 'http://www.jjwxc.net/onebook.php?novelid=2456';

my $r = $xs->get_book($index_url, 
        #with_toc => 1, 
        usr => 'lsyx',
        passwd => 'jjds86',
        wp_url => 'http://novel.idouzi.tk',
        tag => [ '定柔三迷', '古风' ], 
        category => [ '原创' ], 
);

done_testing;
