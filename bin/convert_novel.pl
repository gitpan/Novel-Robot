#!/usr/bin/perl 
use strict;
use warnings;
use Encode;
use Encode::Locale;
use Digest::MD5 qw/md5_base64/;
use Getopt::Std;
use POSIX qw/strftime/;
use utf8;

my %opt;
getopt( 'ftcTo', \%opt );
$opt{t} ||= 'mobi';

if($opt{t} ne 'jekyll'){
    novel_to_any($opt{f}, $opt{t});
}else{
    novel_to_jekyll();
}


sub novel_to_any {
    my ($f, $type) = @_;
    $type ||='mobi';

    my $dst_file = $f;
    $dst_file=~s/[a-z0-9]+$/$type/;

    my ($writer,$book) = $f=~/([^\\\/]+?)-(.+?)\.[^.]+$/;

    `ebook-convert "$f" "$dst_file" --authors "$writer" --title "$book"`;
}


sub novel_to_jekyll {
    my ($writer,$book) = map { decode(locale => $_) } ($opt{f}=~/([^\\\/]+?)-(.+?)\.[^.]+$/);

    my $tags =  $opt{T} ? [ split ',', decode( locale => $opt{T} ) ] : []; 
    push @$tags , ($writer, $book);
    my $tag = join(", ", map { qq["$_"] } @$tags);
    my $category = decode(locale => $opt{c} ) || "";


    open my $fhr, '<:utf8', $opt{f};
    my $first_line = <$fhr>;
    my $o = $opt{o} ? $opt{o} : md5_base64(encode('utf8' => $first_line));
    $o=~s/[^a-z0-9A-Z]//g;

    my $day = strftime "%Y-%m-%d" , localtime;
    open my $fh, '>:utf8', "$day-$o.md";
    print $fh <<"__HEAD__";
---
layout: post
category: "$category"
title:  "$book"
tagline: "$writer"
tags: [ $tag ] 
---
{% include JB/setup %}

$first_line

__HEAD__

while(<$fhr>){
    s/>_</＞＿＜/g;
    s/= =/＝ ＝/g;
    s/^=/＝/g;
    s/[\|]//g;
    s/\*/＊/g;
    s/\[([^\]]+)\](?!\()/［$1］/g;
    print $fh $_;
}
close $fh;
close $fhr;
}
