#!/usr/bin/env perl

use strict;
use warnings;

use v5.14;

use File::Slurper qw(read_lines write_binary);
use WWW::Curl::Easy;
use JSON;
use utf8;

my $url_file = shift || "miniurls.csv";
my $data_dir = shift || "data";

my $curl = WWW::Curl::Easy->new;
$curl->setopt(CURLOPT_HEADER,1);

my @urls = read_lines( $url_file);
my @ids = map  /(\d+)/, @urls;

while ( @ids ) {
  my $id = shift @ids;
  my $file_name =  "$data_dir/airbnb-$id.json";
  next if -e $file_name;
  #  my $page = get( "https://www.airbnb.com/rooms/$id" );
  $curl->setopt(CURLOPT_URL, "https://www.airbnb.com/rooms/$id" );
  $curl->setopt(CURLOPT_FOLLOWLOCATION, 1 );
  my $response_body;
  $curl->setopt(CURLOPT_WRITEDATA,\$response_body);

  say "Descargando $id";
  my $retcode = $curl->perform;
  if ( $retcode == 0 ) {
    #Obtiene el chunk de JSON
    my ($page) = ($response_body =~ /.+?<\/html>/s);
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

