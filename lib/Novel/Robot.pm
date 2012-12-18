#===============================================================================
#  DESCRIPTION:  小说下载、更新引擎
#       AUTHOR:  AbbyPan (USTC), <abbypan@gmail.com>
#===============================================================================
package Novel::Robot;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use Moo;

use Encode qw/encode decode/;

use Novel::Robot::Browser;
use Novel::Robot::Parser::Jjwxc;
use Novel::Robot::Parser::Dddbbb;

has browser => ( is => 'rw', 
    default => sub {
        my ($self) = @_;
        my $browser = new Novel::Robot::Browser();
        return $browser;
    },
);

has site => (
    is => 'rw', 
    default => sub { '' }, 
);

has parser => (
    is => 'rw', 
    lazy => 1, 
    default => \&set_site, 
);

sub set_site {
        my ($self, $site) = @_;
        $self->{site} = $site if($site);
        $self->{parser_list}{$self->{site}} //= eval qq[new Novel::Robot::Parser::$self->{site}()];
        $self->{parser}  = $self->{parser_list}{$self->{site}};
}

sub set_site_by_url {
        my ($self, $url) = @_;

        my $site = ($url=~m#^http://www\.jjwxc\.net/#) ? 'Jjwxc'  :
        ($url=~m#^http://www\.dddbbb\.net/#) ? 'Dddbbb' : ''; 

        $self->set_site($site) if(! $self->{site} or $self->{site} ne $site);
}

sub get_index_ref {

    my ( $self, @args ) = @_;
    
    $self->set_site_by_url($args[0]) if($args[0]=~m#^http://#);

    my ($index_url) = $self->{parser}->generate_index_url(@args);

    my $html_ref = $self->{browser}->get_url_ref($index_url);

    $self->{parser}->alter_index_before_parse($html_ref);
    my $ref = $self->{parser}->parse_index($html_ref);
    return unless ( defined $ref );

    $ref->{index_url} = $index_url;
    $ref->{site}      = $self->{parser}{site};

    return $ref unless ( exists $ref->{book_info_urls} );

    while ( my ( $url, $info_sub ) = each %{ $ref->{book_info_urls} } ) {
        my $info = $self->{browser}->get_url_ref($url);
        next unless ( defined $info );
        $info_sub->( $ref, $info );
    }

    return $ref;
} ## end sub get_index_ref

sub get_chapter_ref {
    my ( $self, @args ) = @_;

    $self->set_site_by_url($args[0]) if($args[0]=~m#^http://#);

    my ( $chap_url, $chap_id ) = $self->{parser}->generate_chapter_url(@args);
    my $html_ref = $self->{browser}->get_url_ref($chap_url);
    return unless ($html_ref);

    $self->{parser}->alter_chapter_before_parse($html_ref);
    my $ref = $self->{parser}->parse_chapter($html_ref);
    return unless ($ref);

    $ref->{content} =~ s#\s*([^><]+)(<br />\s*){1,}#<p>$1</p>\n#g;
    $ref->{content} =~ s#(\S+)$#<p>$1</p>#s;
    $ref->{content} =~ s###g;

    $ref->{chapter_url} = $chap_url;
    $ref->{chapter_id}  = $chap_id;

    return $ref;
} ## end sub get_chapter_ref

sub get_empty_chapter_ref {
    my ( $self, $id ) = @_;

    my %data;
    $data{chapter_id} = $id;

    return \%data;
} ## end sub get_empty_chapter_ref


sub get_writer_ref {
    my ( $self, @args ) = @_;

    $self->set_site_by_url($args[0]) if($args[0]=~m#^http://#);
    my ($writer_url) = $self->{parser}->generate_writer_url(@args);

    my $html_ref = $self->{browser}->get_url_ref($writer_url);

    my $writer_books = $self->{parser}->parse_writer($html_ref);

    return $writer_books;
} ## end sub get_writer_ref

sub get_query_ref {
    my ( $self, $type, $keyword ) = @_;

    my $key = encode( $self->{parser}->charset, $keyword );
    my ( $url, $post_vars ) = $self->{parser}->make_query_url( $type, $key );
    my $html_ref = $self->{browser}->get_url_ref( $url, $post_vars );
    return unless $html_ref;

    my $result          = $self->{parser}->parse_query($html_ref);
    my $result_urls_ref = $self->{parser}->get_query_result_urls($html_ref);
    return $result unless ( defined $result_urls_ref );

    for my $url (@$result_urls_ref) {
        my $h = $self->{browser}->get_url_ref($url);
        my $r = $self->{parser}->parse_query($h);
        push @$result, @$r;
    }

    return $result;
} ## end sub get_query_ref

### }}}

no Moo;
1;
