# Use the official Ubuntu image as the base
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    unzip \
    apache2 \
    mysql-server \
    php \
    php-mysql \
    php-xml \
    php-mbstring \
    php-zip \
    php-cli \
    php-dev \
    autoconf \
    automake \
    libtool \
    git

# Install Xdebug
RUN wget https://xdebug.org/files/xdebug-3.3.2.tgz && \
    tar -xvzf xdebug-3.3.2.tgz && \
    cd xdebug-3.3.2 && \
    phpize && \
    ./configure --enable-xdebug && \
    make && \
    make install && \
    echo "zend_extension=$(find /usr/local/lib/php/extensions -name xdebug.so)" >> /etc/php/7.4/apache2/php.ini && \
    echo "xdebug.mode=debug" >> /etc/php/7.4/apache2/php.ini && \
    echo "xdebug.start_with_request=yes" >> /etc/php/7.4/apache2/php.ini && \
    echo "xdebug.client_host=127.0.0.1" >> /etc/php/7.4/apache2/php.ini && \
    echo "xdebug.client_port=9003" >> /etc/php/7.4/apache2/php.ini && \
    cd .. && rm -rf xdebug-3.3.2 xdebug-3.3.2.tgz

# Install SuiteCRM
RUN wget https://suitecrm.com/files/165/SuiteCRM-7.11.23/SuiteCRM-7.11.23.zip && \
    unzip SuiteCRM-7.11.23.zip -d /var/www/html/ && \
    rm SuiteCRM-7.11.23.zip && \
    chown -R www-data:www-data /var/www/html/SuiteCRM-7.11.23 && \
    chmod -R 755 /var/www/html/SuiteCRM-7.11.23

# Configure Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite && service apache2 restart

# Expose ports
EXPOSE 80 3306 9003

# Start Apache and MySQL
CMD ["sh", "-c", "service mysql start && apache2ctl -D FOREGROUND"]
