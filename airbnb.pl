#!/usr/bin/env perl

use strict;
use warnings;

use v5.14;

use File::Slurper qw(read_lines);
use LWP::Simple;
use JSON;
use utf8;

my $url_file = shift || "miniurls.csv";

my @urls = read_lines( $url_file);

my %data;
my @columns = qw ( Accommodates: Bathrooms: Bedrooms: Beds: limpieza extra finde );
say "ID, ", join(", ", @columns);
for my $u ( @urls ) {
  my ($id) = ($u =~ /(\d+)/);
  my $page = get( $u );
  my ($json_chunk) = ($page =~ /script type="application.json" data-hypernova-key="p3indexbundlejs" data-hypernova-id="\S+"><!--(.+)-->/);
  my $u_data = utf8::is_utf8($json_chunk) ? Encode::encode_utf8($json_chunk) : $json_chunk;
  my $airbnb_data = decode_json $u_data;
  my $space_data = $airbnb_data->{'bootstrapData'}{'listing'}{'space_interface'};
  for my $d (@$space_data) {
    $data{$id}{$d->{'label'}} = $d->{'value'}
  }
  my $price_data = $airbnb_data->{'bootstrapData'}{'listing'}{'price_interface'};
  $data{$id}{'limpieza'} = $price_data->{'cleaning_fee'}{'value'};
  $data{$id}{'extra'} = $price_data->{'extra_people'}{'value'};
  $data{$id}{'finde'} = $price_data->{'weekend_price'}{'value'};

  #Print now
  print "$id";
  for my $c ( @columns ) {
    if (!$data{$id}{"$c"}) {
      print ", ";
      next;
    }
    my $u_data = utf8::is_utf8($data{$id}{"$c"}) ? Encode::encode_utf8($data{$id}{"$c"}) : $data{$id}{"$c"};
    print ", $u_data";
  }
  print "\n";
}

