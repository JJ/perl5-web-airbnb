FROM scottw/alpine-perl
MAINTAINER JJ Merelo <jjmerelo@GMail.com>

RUN mkdir -p /root/data
WORKDIR /root

COPY cpanfile airbnb-descarga.pl /root/
COPY idsminitest.csv /root/miniurls.csv
RUN cpanm --installdeps .
RUN chmod +x airbnb-descarga.pl

ENTRYPOINT ["./airbnb-descarga.pl"]
