# Use an official PHP runtime
FROM php:7.4-apache

# Install necessary packages and PHP extensions
RUN apt-get update && apt-get install -y \
    curl \
    unzip

# Enable Apache modules
RUN a2enmod rewrite

# Copy the Apache configuration file to the container
COPY docker_apache.conf /etc/apache2/sites-enabled/000-default.conf

# Install any extensions you need
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Download the source files from the provided URL
RUN curl -L -o /tmp/ts-website.zip https://github.com/Wruczek/ts-website/releases/download/dev-2.1.0/ts-website-dev-2.1.0-60fb088.zip

# Unzip the downloaded file to a temporary directory
RUN unzip /tmp/ts-website.zip -d /tmp/

# Move the ts-website directory to the Apache document root
RUN mv /tmp/ts-website/* /var/www/html/

# Copy the HTML-Rules into the webapp
COPY docker_rules.latte /var/www/html/private/templates/rules.latte

# Set permissions for the Apache web server
RUN chown -R www-data:www-data /var/www/html
