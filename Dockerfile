# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: ldideric <ldideric@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/09 00:02:37 by nben-ezr      #+#    #+#                  #
#    Updated: 2020/06/18 14:50:55 by ldideric      ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

LABEL maintainer="Lietze Diderich ldideric"

# update
RUN apt-get update -y && \
	apt-get upgrade -y

# install requirements
RUN apt-get install \
	wget \
	nginx \
	mariadb-server mariadb-client \
	php php-cli php-fpm php-cgi php-mysql php-mbstring \
	php-mbstring \
	php-pear \
	openssl \
	mcrypt -y && \
	rm -rf /var/lib/apt/lists/*

# Adding all sources to the image
COPY srcs srcs

RUN mkdir -p var/www/localhost
#mkdir -p var/www/localhost/phpmyadmin
#RUN		echo "Help" > /var/www/localhost/index.php

# copying localhost config file to nginx folder
RUN cp srcs/localhost /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost

# install wordpress
RUN tar xvfz srcs/*.tar.gz
RUN cp srcs/wp-config.php wordpress/
RUN mv wordpress var/www/localhost

# connecting SQL to PHP
#RUN pecl install sqlsrv pdo_sqlsrv

# generate SSL certificate
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt; 

#80: http		443: https
EXPOSE 80 443

# start up nginx, mysql and php inside image
CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	tail -f /dev/null
