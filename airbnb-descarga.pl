#!/usr/bin/env perl

use strict;
use warnings;

use v5.14;

use File::Slurper qw(read_lines write_binary);
use LWP::Simple;
use JSON;
use utf8;

my $url_file = shift || "urls-error.csv";
my $data_dir = shift || "data";

my @urls = read_lines( $url_file);
my @ids = map  /(\d+)/, @urls;

while ( @ids ) {
  my $id = shift @ids;
  my $page = get( "https://www.airbnb.com/rooms/$id" );
  say "Descargando $id";
  if ( $page ) {
    my ($json_chunk) = ($page =~ /script type="application.json" data-hypernova-key="p3indexbundlejs" data-hypernova-id="\S+"><!--(.+)-->/);
    if (!$json_chunk) {
      say "$id No longer available";
    } else {
      my $u_data = utf8::is_utf8($json_chunk) ? Encode::encode_utf8($json_chunk) : $json_chunk;
      write_binary("$data_dir/airbnb-$id.json",$u_data)
    }
  } else {
    say "Error en $id";
    push @ids, $id;
    sleep 2;
  }
}

