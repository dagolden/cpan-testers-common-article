#!/usr/bin/perl -w
use strict;
use Test::More tests => 20;
use CPAN::Testers::Common::Article;
use IO::File;

my @perls = (
  {
    text => 'Summary of my perl5 (revision 5.0 version 6 subversion 1) configuration',
    perl => '5.6.1'
  },
  {
    text => 'Summary of my perl5 (revision a version b subversion c) configuration',
    perl => '0'
  },
  {
    text => 'Summary of my perl5 (revision 5.0 version 8 subversion 0 patch 17332) configuration',
    perl => '5.8.0 patch 17332',
  },
  {
    text => 'Summary of my perl5 (revision 5.0 version 8 subversion 1 RC3) configuration',
    perl => '5.8.1 RC3',
  },
  {
    text => 'Summary of my perl5 (revision 5 patchlevel 6 subversion 1) configuration',
    perl => '5.6.1',
  },
  {
    text => 'on Perl 5.8.8, created by CPAN-Reporter',
    perl => '5.8.8',
  },
  {
    text => 'on perl 5.8.8, created by CPAN-Reporter',
    perl => '5.8.8',
  },
#  {
#    text => '',
#    perl => '',
#  },
);

my $article = readfile('t/nntp/126015.txt');
my $ctca = CPAN::Testers::Common::Article->new($article);
isa_ok($ctca,'CPAN::Testers::Common::Article');

for(@perls) {
  my $text = $_->{text};
  my $perl = $_->{perl};

  my $version = $ctca->_extract_perl_version(\$text);
  is($version, $perl,".. matches perl $perl");
}

my @testdates = (
    ['Wed, 13 September 2004','200409','200409130000'],
    ['13 September 2004','200409','200409130000'],
    ['September 22, 1999 06:29','199909','199909220629'],

    ['Wed, 13 September 1990','000000','000000000000'],
    ['13 September 1990','000000','000000000000'],
    ['September 22, 1990 06:29','000000','000000000000'],
);

for my $row (@testdates) {
    my ($d1,$d2) = $ctca->_extract_date($row->[0]);
    is($d1,$row->[1],".. short date parse of '$row->[0]'");
    is($d2,$row->[2],".. long date parse of '$row->[0]'");
}

sub readfile {
    my $file = shift;
    my $text;
    my $fh = IO::File->new($file)   or return;
    while(<$fh>) { $text .= $_ }
    $fh->close;
    return $text;
}