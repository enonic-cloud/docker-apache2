# Base image
FROM ubuntu:14.04
#### Inspired by the tianon/apache2 image ####
LABEL "creator"="Erik Kaareng-Sunde erikks@redpill-linpro.com"
LABEL "maintainer"="Diego Pasten dap@enonic.com"

# let's copy a few of the settings from /etc/init.d/apache2
ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C

RUN apt-get update \
  && apt-get upgrade \
  && apt-get install -y apache2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

# make CustomLog (access log) go to stdout instead of files
# and ErrorLog to stderr
RUN find "$APACHE_CONFDIR" -type f -exec sed -ri ' \
    s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
    s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
' '{}' ';'

COPY sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY sites-available/statuspage.conf /etc/apache2/sites-available/statuspage.conf

RUN a2ensite default-ssl \
  && a2enmod ssl \
  && a2ensite statuspage

EXPOSE 80 443 8001

CMD apache2 -DFOREGROUND
