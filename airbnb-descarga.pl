#!/usr/bin/env perl

use strict;
use warnings;

use v5.14;

use File::Slurper qw(read_lines write_binary);
use LWP::Simple;
use JSON;
use utf8;

my $url_file = shift || "miniurls.csv";
my $data_dir = shift || "data";

my @urls = read_lines( $url_file);
my @ids = map  /(\d+)/, @urls;

while ( @ids ) {
  my $id = shift @ids;
  my $file_name =  "$data_dir/airbnb-$id.json";
  next if -e $file_name;
  my $page = get( "https://www.airbnb.com/rooms/$id" );
  say "Descargando $id";
  if ( $page ) {
    #Obtiene el chunk de JSON
    my ($json_chunk) = ($page =~ /script type="application.json" data-hypernova-key="p3indexbundlejs" data-hypernova-id="\S+"><!--(.+)-->/);
    if (!$json_chunk) {
      say "$id No longer available";
    } else {
      my $u_data = utf8::is_utf8($json_chunk) ? Encode::encode_utf8($json_chunk) : $json_chunk;

      my $airbnb_data = decode_json $u_data;
      $airbnb_data->{'airbnb_id'} = $id;
      write_binary($file_name,encode_json( $airbnb_data ) );

    }
    sleep 5*rand();
  } else {
    say "Error en $id";
    push @ids, $id;
    sleep 15*rand();
  }
}

