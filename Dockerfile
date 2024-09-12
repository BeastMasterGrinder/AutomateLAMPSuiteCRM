# Use the official Ubuntu image as the base
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    unzip \
    autoconf \
    automake \
    libtool \
    nano \
    php-pear \
    php-dev \
    php-cli \
    net-tools \
    systemctl

# Download and install XAMPP
RUN wget -O /tmp/xampp-installer.run "https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.12/xampp-linux-x64-8.2.12-0-installer.run/download?use_mirror=yer" && \
    chmod +x /tmp/xampp-installer.run && \
    /tmp/xampp-installer.run --mode unattended && \
    rm /tmp/xampp-installer.run

# Download and install SuiteCRM
RUN wget https://github.com/salesagility/SuiteCRM-Core/releases/download/v8.2.1/SuiteCRM-8.2.1.zip -O /tmp/SuiteCRM-8.2.1.zip && \
    mv /tmp/SuiteCRM-8.2.1.zip /opt/lampp/htdocs && \
    unzip /opt/lampp/htdocs/SuiteCRM-8.2.1.zip -d /opt/lampp/htdocs/SuiteCRM-8.2.1 && \
    ls -l /opt/lampp/htdocs/ && \
    rm /opt/lampp/htdocs/SuiteCRM-8.2.1.zip && \
    chown -R www-data:www-data /opt/lampp/htdocs/SuiteCRM-8.2.1 && \
    chmod -R 755 /opt/lampp/htdocs/SuiteCRM-8.2.1

# Configure PHP and Xdebug
RUN wget https://github.com/xdebug/xdebug/releases/download/3.3.1/php_xdebug-3.3.1-8.2-vs16-x86_64 -O /tmp/xdebug.so && \
    mv /tmp/xdebug.so /opt/lampp/lib/php/extensions/ && \
    echo "[xdebug]" >> /opt/lampp/etc/php.ini && \
    echo "zend_extension=/opt/lampp/lib/php/extensions/xdebug.so" >> /opt/lampp/etc/php.ini && \
    echo "xdebug.mode=debug" >> /opt/lampp/etc/php.ini && \
    echo "xdebug.start_with_request=yes" >> /opt/lampp/etc/php.ini && \
    echo "xdebug.client_host=127.0.0.1" >> /opt/lampp/etc/php.ini && \
    echo "xdebug.client_port=9003" >> /opt/lampp/etc/php.ini

# Set environment variables for XAMPP
ENV PATH="/opt/lampp/bin:${PATH}"

# Expose ports
EXPOSE 80 3306 9003

# Start XAMPP
CMD ["/opt/lampp/lampp", "start"]

