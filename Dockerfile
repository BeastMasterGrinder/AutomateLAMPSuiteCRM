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
    nano

# Download and install XAMPP
RUN wget -O /tmp/xampp-installer.run "https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.12/xampp-linux-x64-8.2.12-0-installer.run/download?use_mirror=yer" && \
    chmod +x /tmp/xampp-installer.run && \
    /tmp/xampp-installer.run --mode unattended && \
    rm /tmp/xampp-installer.run

# Download and install SuiteCRM
RUN wget https://github.com/salesagility/SuiteCRM-Core/releases/download/v8.2.1/SuiteCRM-8.2.1.zip -O /tmp/SuiteCRM-8.2.1.zip && \
    unzip /tmp/SuiteCRM-8.2.1.zip -d /opt/lampp/htdocs/ && \
    rm /tmp/SuiteCRM-8.2.1.zip && \
    chown -R daemon:daemon /opt/lampp/htdocs/SuiteCRM-7.11.23 && \
    chmod -R 755 /opt/lampp/htdocs/SuiteCRM-7.11.23

# Configure PHP and Xdebug
RUN echo 'export PATH="/opt/lampp/bin:$PATH"' >> ~/.bashrc && \
    source ~/.bashrc && \
    wget https://xdebug.org/files/xdebug-3.3.2.tgz -O /tmp/xdebug-3.3.2.tgz && \
    tar -xvzf /tmp/xdebug-3.3.2.tgz -C /tmp && \
    cd /tmp/xdebug-3.3.2 && \
    phpize && \
    ./configure --enable-xdebug && \
    make && \
    make install && \
    echo "[xdebug]" >> /opt/lampp/etc/php.ini && \
    echo "zend_extension=$(find /opt/lampp/lib/php/extensions -name xdebug.so)" >> /opt/lampp/etc/php.ini && \
    echo "xdebug.mode=debug" >> /opt/lampp/etc/php.ini && \
    echo "xdebug.start_with_request=yes" >> /opt/lampp/etc/php.ini && \
    echo "xdebug.client_host=127.0.0.1" >> /opt/lampp/etc/php.ini && \
    echo "xdebug.client_port=9003" >> /opt/lampp/etc/php.ini && \
    rm -rf /tmp/xdebug-3.3.2 /tmp/xdebug-3.3.2.tgz

# Expose ports
EXPOSE 80 3306 9003

# Start XAMPP
CMD ["/opt/lampp/lampp", "start"]