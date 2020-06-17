# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: ldideric <ldideric@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/09 00:02:37 by nben-ezr      #+#    #+#                  #
#    Updated: 2020/06/17 18:06:28 by ldideric      ########   odam.nl          #
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
	mariadb-server \
	mariadb-client \
	php php-cli \
	php-fpm \
	php-cgi \
	php-mysql \
	php-mbstring \
	openssl \
	mcrypt \
	php-mbstring \
	php-pear -y && \
	rm -rf /var/lib/apt/lists/*

# generate SSL certificate
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt; 

# copying sources to docker image
ADD srcs/localhost /etc/nginx/sites-enabled/localhost

# connecting SQL to PHP
#RUN pecl install sqlsrv pdo_sqlsrv

# install wordpress
RUN mkdir wordpress_temp
COPY srcs/wordpress-5.3.2-nl_NL.tar.gz wordpress_temp
RUN tar xvfz ./wordpress_temp/* && \
	rm -rf wordpress_temp wordpress/wp-config-sample.php
COPY srcs/wp-config.php wordpress/

#80: http		443: https
EXPOSE 80 443

# start up nginx, mysql and php inside image
CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start \
	tail -f /dev/null
