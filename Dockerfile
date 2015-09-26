FROM debian:jessie

MAINTAINER Nicolas Marchildon

RUN apt-get update
RUN apt-get install -y ikiwiki
RUN apt-get install -y python
RUN apt-get install -y apache2
#RUN apt-get clean

RUN useradd -ms /bin/bash ikiwiki
WORKDIR /home/ikiwiki
USER ikiwiki
RUN git config --global user.email "you@example.com" && \
  git config --global user.name "Your Name"
RUN export USER=ikiwiki ; \
  echo $'wiki\n\nadmin\nadmin\nadmin' | \
  ikiwiki --setup /etc/ikiwiki/auto.setup && \
  ikiwiki --changesetup wikiwiki.setup --plugin 404 && \
  ikiwiki --setup wikiwiki.setup
VOLUME ["/home/ikiwiki"]

USER root
RUN a2enmod cgi
RUN echo 'AddHandler cgi-script .cgi' >> /etc/apache2/apache2.conf
RUN echo '\
<VirtualHost *:80>\n\
    ServerName example.ikiwiki.info:80\n\
    DocumentRoot /home/ikiwiki/public_html/wikiwiki\n\
    <Directory /home/ikiwiki/public_html/wikiwiki>\n\
        Options Indexes MultiViews ExecCGI\n\
        AllowOverride None\n\
        Require all granted\n\
    </Directory>\n\
    ScriptAlias /ikiwiki.cgi /home/ikiwiki/public_html/wikiwiki/ikiwiki.cgi\n\
    ErrorDocument 404 "/ikiwiki.cgi"\n\
</VirtualHost>\n\
' > /etc/apache2/sites-available/000-default.conf

CMD /usr/sbin/apache2ctl -D FOREGROUND
EXPOSE 80

