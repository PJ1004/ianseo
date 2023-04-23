FROM php:8.2-apache

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
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /usr/local/etc/php/php.ini
RUN sed -i 's/max_execution_time = 30/max_execution_time = 120/g' /usr/local/etc/php/php.ini
RUN sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /usr/local/etc/php/php.ini

# Config for default apache website
COPY ./src/apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

########################################################
# Setup IANSEO
RUN mkdir -p /opt/ianseo

## Comment out RUN lines if copying file locally
RUN wget https://www.ianseo.net/Release/Ianseo_20230401.zip && unzip -o Ianseo_20230401.zip -d /opt/ianseo
RUN rm Ianseo_20230401.zip

## Uncomment out COPY & RUN (unzip) line if not pulling direct from IANSEO website
#COPY ./src/Ianseo_20230401.zip /tmp/Ianseo_20230401.zip
#RUN unzip -o /tmp/Ianseo_20230401.zip -d /opt/ianseo && rm /tmp/*.zip

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
