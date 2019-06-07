FROM debian:jessie
MAINTAINER Pierre DAVID <pierre.david@c-s.fr>
EXPOSE 80 443

# Proxy if needed
# COPY ./config/proxy/proxy.sh /etc/profile.d/proxy.sh
# COPY ./config/proxy/99HttpProxy /etc/apt/apt.conf.d/99HttpProxy
RUN apt-get update
RUN apt-get install -y -f curl
RUN apt-get install -y -f wget
# COPY ./config/proxy/wgetrc /etc/wgetrc

# APACHE 2.24 + PHP 5.6.4
RUN  apt-get install -y apache2
RUN  apt-get install -y libapache2-mod-php5
RUN  apt-get install -y php5
RUN  apt-get install -y php5-ldap
RUN  apt-get install -y php5-intl
#RUN apt-get install -y php5-opcache (Zend_Opcache included)
#RUN apt-get install -y php-xml (mod included)
#RUN apt-get install -y php-xml-parser (mod included)
#RUN apt-get install -y php-zip  (mod included, add php-pclzip for ZipArchive)
RUN  apt-get install -y php5-common
RUN  apt-get install -y php5-curl
RUN  apt-get install -y php5-json
RUN  apt-get install -y php5-mcrypt
RUN  apt-get install -y php5-cli
RUN  apt-get install -y php5-pgsql
RUN  apt-get install -y php5-xsl 
RUN  apt-get install -y php5-ssh2
RUN  apt-get install -y php5-twig
RUN  apt-get install -y php5-gd
RUN  apt-get install -y php5-xdebug
#RUN apt-get install -y php5-sqlite3
#RUN apt-get install -y php5-soap
RUN  apt-get install -y php5-mysql
RUN  apt-get install -y vim
RUN  apt-get install -y nano

# Copy package (php5-sqlite3)
RUN   rm -rf /tmp/*
COPY ./packages/php5-sqlite_5.6.40+dfsg-0+deb8u2_amd64.deb /tmp/php5-sqlite_5.6.40+dfsg-0+deb8u2_amd64.deb
RUN (for d in `ls /tmp`;do dpkg -i /tmp/$d; done);
RUN apt-get -f install

# Clean up
RUN   apt-get clean
RUN   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN   rm -rf ./var/www/*
RUN   chgrp -R www-data /var/www
RUN   chmod -R 0775 /var/www
RUN   chmod g+s /var/www

# Default config
COPY ./config/apache2.conf /etc/apache2/apache2.conf
COPY ./config/ports.conf /etc/apache2/ports.conf
COPY ./config/php.ini /etc/php5/apache2/php.ini
COPY ./config/init.sh /usr/sbin/init.sh
RUN chmod 0775 /usr/sbin/init.sh
RUN a2dissite 000-default.conf
RUN rm -rf /etc/apache2/sites-enabled/*
RUN rm -rf /etc/apache2/sites-available/*
RUN openssl req -new -x509 -days 3650 -nodes -out /etc/ssl/certs/apache-selfsigned.pem -keyout /etc/ssl/certs/apache-selfsigned.key -subj "/C=FR/ST=Toulouse/L=Toulouse/O=Dev/OU=Dev/CN=localhost.com"
RUN a2enmod ssl
RUN a2enmod rewrite

# VOLUME
VOLUME ["/var/www", "/etc/apache2/sites-available"]

RUN service apache2 restart

# BOOTLOAD
ENTRYPOINT "/usr/sbin/init.sh" && /bin/bash

