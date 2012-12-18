#!/usr/bin/perl 
#===============================================================================
#  DESCRIPTION:  TERM下面选择下载小说
#       AUTHOR:  AbbyPan (USTC), <abbypan@gmail.com>
#===============================================================================
use strict;
use warnings;
use utf8;
use JSON;
use Encode::Locale;
use Encode;
use Term::Menus;

use Getopt::Std;

$| = 1;

my %opt;
getopt( 'wskvmt', \%opt );
#w : writer
#s(query) : site
#k(query) : keyword
#v(query) : value
#m : select menu
#t : to txt / to html / to wordpress ...

my $cmd = $opt{w} ? qq[get_writer_to_json.pl $opt{w}] : qq[get_query_to_json.pl $opt{s} $opt{k} $opt{v}];
print $cmd;
my $json = `$cmd`;
my $info = decode_json( $json );

my $select = $opt{m} ? select_book($info) : $info; 
print $_->[2],"\n" for @$select;
for my $r (@$select){
    my $u = $r->[2];
    my $c = $opt{t};
    $c=~s/{url}/$u/;
    system($c);
}

sub select_book {
    my ($info_ref ) = @_;

    my %menu = ( 'Select' => 'Many', 'Banner' => 'Book List', );

    #菜单项，不搞层次了，恩
    my %select;
    my $i = 1;
    for my $r (@$info_ref) {
        my ( $info, $key, $url ) = @$r;
        my $item = "$info --- $key";
        $select{$item} = $url;
        $item = encode( locale => $item );
        $menu{"Item_$i"} = { Text => $item };
        $i++;
    } ## end for my $r (@$info_ref)

    #最后选出来的小说
    my @select_result;
    for my $item ( &Menu( \%menu ) ) {
        $item = decode( locale => $item );
        my ( $info, $key ) = ( $item =~ /^(.*) --- (.*)$/ );
        push @select_result, [ $info, $key, $select{$item} ];
    }

    return \@select_result;

} ## end sub select_book
