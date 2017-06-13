# perl5-web-airbnb

This is a simple Perl script for scraping AirBNB pages.

## Install

You need to have a Perl version > 5.14. You might want to use `perlbrew` to install it, or go with your system Perl. `perlbrew` also install `cpanm`, so you can do this directly

	cpanm --installdeps . 
	
to install needed modules.

## Run

Takes a set of URLs in a text file, just like [miniurls.csv](miniurls.csv). Run it like

	./airbnb.pl urls.csv
	
or without an argument if you want to go with the filename `miniurls.csv`. It will print to standard output something similar to [`test.csv`](test.csv). 

## To do

Right now it just crashes if some URL is not available. Some better error handling will have to be done. More [to do](TODO.md), in its own file. 
