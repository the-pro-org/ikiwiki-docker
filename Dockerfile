FROM debian:jessie

MAINTAINER Nicolas Marchildon

RUN apt-get update
RUN apt-get install -y ikiwiki
RUN apt-get install -y python
RUN apt-get install -y apache2
#RUN apt-get clean

RUN useradd -m ikiwiki
WORKDIR /home/ikiwiki
USER ikiwiki
RUN git config --global user.email "you@example.com" && \
  git config --global user.name "Your Name"
RUN cp /etc/ikiwiki/auto.setup example.setup
RUN sed -i 's/add_plugins =>.*/add_plugins => [qw{goodstuff websetup 404}],/' example.setup
RUN echo $'wiki\n\nadmin\nadmin\nadmin' | ikiwiki --setup example.setup
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

