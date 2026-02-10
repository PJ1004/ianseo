FROM docker.io/php:8.5-apache

# Initial package installs
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get update && apt-get install -y \
        supervisor \
        git \
        curl \
        wget \
        unzip

# Setup startup scripts and supervisor settings
COPY ./src/start-apache2.sh /opt/start-apache2.sh
COPY ./src/start.sh /opt/start.sh
RUN chmod 755 /opt/*.sh
COPY ./src/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./src/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

########################################################
# Setup PHP
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync
# Install IANSEO php plugins
RUN apt install -y imagemagick
RUN install-php-extensions mbstring gd curl mysqli xml zip imagick intl
# Optional PHP INFO to be used for checking settings (Comment out COPY if not needed)
COPY --chown=www-data:www-data ./src/info.php /var/www/html/info.php
# Configure PHP settings
ENV PHP_CONF=/usr/local/etc/php/php.ini
RUN cp /usr/local/etc/php/php.ini-production $PHP_CONF
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' $PHP_CONF
RUN sed -i 's/max_execution_time = 30/max_execution_time = 120/g' $PHP_CONF
RUN sed -i 's/post_max_size = 8M/post_max_size = 16M/g' $PHP_CONF
RUN sed -i 's/;extension=intl/extension=imagick\n;extension=intl/g' $PHP_CONF

# Config for default apache website
COPY ./src/apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

########################################################
# Setup IANSEO
RUN mkdir -p /opt/ianseo

## Comment out RUN lines if copying file locally
ENV IANSEO_RELEASE=Ianseo_20250210
RUN wget https://www.ianseo.net/Release/${IANSEO_RELEASE}.zip && unzip -o ${IANSEO_RELEASE}.zip -d /opt/ianseo
RUN rm ${IANSEO_RELEASE}.zip

# Uncomment out COPY & RUN (unzip) line if not pulling direct from IANSEO website
# COPY ./src/${IANSEO_RELEASE}.zip /tmp/${IANSEO_RELEASE}.zip
# RUN unzip -o /tmp/${IANSEO_RELEASE}.zip -d /opt/ianseo && rm /tmp/*.zip

RUN chown -R www-data:www-data /opt/ianseo
RUN ln -s /opt/ianseo /var/www/html/ianseo
RUN chown -R www-data:www-data /var/www/html


## Remove first-time config or copy your own
#RUN rm /opt/ianseo/Common/config.inc.php
#COPY ./src/config.inc.php /opt/ianseo/Common/config.inc.php

########################################################
##Cleanup
RUN apt-get -y autoremove && apt-get clean all

EXPOSE 80

# Start services via supervisord
CMD ["/opt/start.sh"]
