# ABSTRACT: download novel 小说下载器
package Novel::Robot;
use strict;
use warnings;
use utf8;

use Encode::Locale;
use Encode;
use Term::Menus;
use Parallel::ForkManager;

use Novel::Robot::Parser;
use Novel::Robot::Packer;

our $VERSION = 0.31;

sub new {
    my ( $self, %opt ) = @_;
    $opt{max_process_num} ||= 3;
    $opt{type}            ||= 'html';

    my $parser  = Novel::Robot::Parser->new(%opt);
    my $packer  = Novel::Robot::Packer->new(%opt);
    my $browser = $parser->{browser};
    bless { %opt, parser => $parser, packer => $packer, browser => $browser },
      __PACKAGE__;
}

sub set_parser {
    my ( $self, $site ) = @_;
    $self->{site} = $self->{parser}->detect_site($site);
    bless $self->{parser}, "Novel::Robot::Parser::$self->{site}";
} ## end sub set_parser

sub set_packer {
    my ( $self, $type ) = @_;
    $self->{type} = $type;
    bless $self->{packer}, "Novel::Robot::Packer::$self->{type}";
} ## end sub set_packer

sub get_book {
    my ( $self, $index_url, %o ) = @_;

    my $book_ref = $self->{parser}->get_book_ref( $index_url, %o );
    return unless ($book_ref);

    $self->{packer}->format_book_output( $book_ref, \%o );
    $self->{packer}->main( $book_ref, %o );
} ## end sub get_book

sub select_book {
    my ( $self, $info_ref ) = @_;

    my %menu = ( 'Select' => 'Many', 'Banner' => 'Book List', );

    #菜单项，不搞层次了，恩
    my %select;
    my $i = 1;
    for my $r (@$info_ref) {
        my $info = $r->{series} || $r->{writer} || '';
        my $item = "$info --- $r->{book}";
        $select{$item} = $r->{url};
        $item = encode( locale => $item );
        $menu{"Item_$i"} = { Text => $item };
        $i++;
    } ## end for my $r (@$info_ref)

    #最后选出来的小说
    my @select_result;
    for my $item ( &Menu( \%menu ) ) {
        $item = decode( locale => $item );
        my ( $info, $book ) = ( $item =~ /^(.*) --- (.*)$/ );
        push @select_result,
          { info => $info, book => $book, url => $select{$item} };
    }

    return \@select_result;

} ## end sub select_book

sub split_id_list {

    #1,3,9-11
    my ( $self, $id_list ) = @_;

    my @id_list = split ',', $id_list;

    my @chap_ids;
    for my $i (@id_list) {
        my ( $s, $e ) = split '-', $i;
        $e ||= $s;
        push @chap_ids, ( $s .. $e );
    }

    return \@chap_ids;
}

1;

=pod

=encoding utf8

=head1 名称

L<Novel::Robot> 小说下载器

=head1 说明

=head2 支持小说站点

    Jjwxc   : http://www.jjwxc.net
    Dddbbb  : http://www.dddbbb.net
    Nunu    : http://book.kanunu.org
    Shunong : http://book.shunong.com
    Asxs    : http://www.23hh.com
    Luoqiu  : http://www.luoqiu.com

=head2 支持小说输出形式

    html
    markdown
    txt
    wordpress

=head1 工具

=head2 下载小说

    get_novel.pl -b [小说目录页url] -t [目标文件类型] -C [是否写目录] -S [是否显示进度条] -i [章节]

    get_novel.pl -b "http://www.dddbbb.net/html/18451/index.html" -t txt
    get_novel.pl -b "http://www.jjwxc.net/onebook.php?novelid=2456" -t html
    get_novel.pl -b "http://www.jjwxc.net/onebook.php?novelid=2456" -t Markdown

    get_novel.pl -w [作者] -b [书名] -f [txt文件或目录] -r [章节标题匹配的正则式] -t [目标文件类型]
    get_novel.pl -w 顾漫 -b 何以笙箫默 -f hy1.txt -t html
    get_novel.pl -w 顾漫 -b 何以笙箫默 -f hy1.txt,hy2.txt,dir1 -r "第[ \\t\\d]+章" -t html

=head2 分段下载小说

    get_novel_split.pl -b [小说目录页url] -t [目标类型] -n [分段章节数] -C [是否写目录] -S [是否显示进度条]

    get_novel_split.pl -b "http://www.jjwxc.net/onebook.php?novelid=2456" -n 10 -t markdown

=head2 将小说发布到wordpress

    put_novel.pl -b [小说目录页url] -c [类别] -T [标签] -W [wordpress页面地址] -u [用户名] -p [密码] 

    put_novel.pl -b "http://www.dddbbb.net/html/18451/index.html" -c 言情 -W http://xxx.xxx.com  -u xxx -p xxx
    put_novel.pl -b "http://www.jjwxc.net/onebook.php?novelid=2456" -c 原创 -W http://xxx.xxx.com  -u xxx -p xxx

    put_novel.pl -w [作者名] -b [用户名] -f [源文件] -c [类别] -T [标签] -W [wordpress页面地址] -u [用户名] -p [密码] 
    put_novel.pl -w 顾漫 -b 何以笙箫默 -f hy.txt -c 言情 -W http://xxx.xxx.com  -u xxx -p xxx
    put_novel.pl -w 施定柔 -b 迷行记 -f mx1.txt,mx2.txt -c 言情 -W http://xxx.xxx.com  -u xxx -p xxx

=head2 转换小说格式
    
    convert_novel.pl -f [源文件] -t [目标文件类型(小写)]

    需要预先安装calibre的ebook-convert，源文件名称格式为 [作者-书名]

    convert_novel.pl -f 施定柔-迷侠记.html -t mobi
    convert_novel.pl -f 施定柔-迷侠记.html -t epub

    convert_novel.pl -f [源文件] -t jekyll -T [标签] -c [类别] -o [目标文件名]

    convert_novel.pl -f  施定柔-迷侠记.html -t jekyll -T "定柔三迷,楚荷衣" -c "原创"

=head2 批量处理小说(支持to txt/html/...)

    novel_robot.pl -w [writer_url] -m [select_menu_or_not] -t [packer_type]
    novel_robot.pl -s [site] -q [query_type] -k [query_keyword] -m [select_menu_or_not] -t [packer_type]

    novel_robot.pl -w "http://www.jjwxc.net/oneauthor.php?authorid=3243" -m 1 -t html
    novel_robot.pl -s Jjwxc -q 作品 -k 何以笙箫默 -m 1 -t html

=head1 命令行参数

    -b : book url，小说目录页 / book name，书名
    -c : categories，小说类别，例如 原创
    -f : 指定文本来源(可以是单个目录或文件)
    -i : chapter ids，章节序号，例如 1，或者 4-7
    -k : 查询的关键字
    -m : 是否输出小说选择菜单
    -p : wordpress 密码
    -q : 查询的类型
    -r : 指定分割章节的正则表达式(例如："第[ \\t\\d]+章")
    -s : 指定查询的站点
    -t : 小说保存类型，例如txt/html
    -o : 保存的小说文件名
    -n : 单个文件最大章节数(一本小说可以分多个文件，每个文件最多n章)
    -C : 小说保存时是否生成目录(默认是)
    -S : 显示进度条(默认显示)
    -T : tags，标签，例如 顾漫
    -u : wordpress 用户
    -w : writer url 作者专栏URL / writer name 作者名
    -W : wordpress 地址

=head1 函数

=head2 new 初始化

设置解析引擎，目标文件类型

    my $xs = Novel::Robot->new(
    site => 'Jjwxc',
    type => 'html', 
    );

=head2 set_parser 设置解析引擎

    $xs->set_parser('Jjwxc');

=head2 set_packer 设置打包引擎

    $xs->set_packer('html');

=head2 get_book 下载整本小说

    $xs->set_parser('Jjwxc');
    my $index_url = 'http://www.jjwxc.net/onebook.php?novelid=2456';
    $xs->get_book($index_url);


    $xs->set_parser('txt');
    $xs->get_book({ writer => '顾漫', book => '何以笙箫默', 
            path => [ '/somepath/somefile.txt' ] });

=head2 select_book 在Term下选择小说

    $xs->set_parser('Jjwxc');

    my $writer_url = 'http://www.jjwxc.net/oneauthor.php?authorid=3243';
    my $writer_ref = $xs->{parser}->get_writer_ref($writer_url);
    my $select_ref = $xs->select_book($writer_ref);

    my $query_type = '作者';
    my $keyword='顾漫';
    $books_ref = $xs->{parser}->get_query_ref($query_type, $keyword);
    my $select_ref = $xs->select_book($query_ref);

=cut
