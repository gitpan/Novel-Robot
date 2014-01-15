#!/usr/bin/perl 
use strict;
use warnings;
use utf8;

use Getopt::Std;
use Encode::Locale;
use Encode;

use Novel::Robot;

$| = 1;

my %opt;
getopt( 'wfrbt', \%opt );

my $xs = Novel::Robot->new();

$xs->set_packer( $opt{t} || 'TXT') ;

if($opt{f}){
    $xs->set_parser('TXT');
    my @path = split ',', $opt{f};
    my $r = $xs->{parser}->parse_index(\@path,
        writer => decode(locale => $opt{w}), 
        book => decode(locale =>$opt{b}),
        chapter_regex => $opt{r} ? decode( locale => $opt{r} ) : undef, 
    );
    $xs->{packer}->pack_book($r);
}else{
    my $index_url = $opt{b};
    $xs->set_parser($index_url);
    $xs->get_book($index_url);
}
