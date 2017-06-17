#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurper qw(read_lines);

use v5.14;

my $url_file = shift || "urls-error.csv";
my $data_dir = shift || "data";

my @urls = read_lines( $url_file);
my @ids = map  /(\d+)/, @urls;

while ( @ids ) {
  my $id = shift @ids;
  my $file_name =  "$data_dir/airbnb-$id.json";
  next if -e $file_name;

  my $output = `phantomjs --cookies-file=/tmp/these-are-cookies.txt airbnb-descarga-id.pjs $id $data_dir`;
  sleep 10*rand();

}

