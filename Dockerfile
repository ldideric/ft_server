# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: ldideric <ldideric@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/09 00:02:37 by nben-ezr      #+#    #+#                  #
#    Updated: 2020/06/30 21:12:41 by ldideric      ########   odam.nl          #
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
	php php-cli php-fpm php-cgi php-mysql php-mbstring php-pear \
	openssl \
	mcrypt -y && \
	rm -rf /var/lib/apt/lists/*

# Adding all sources to the image
COPY srcs srcs
RUN mkdir -p var/www/localhost
RUN chmod +x srcs/autoindex.sh

# generate SSL certificate
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt;

# copying localhost config file to nginx folder
RUN cp srcs/localhost /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost

# install mysql
RUN mv srcs/user.sql /tmp && \
	mv srcs/db.sql /tmp && \
	mv srcs/wordpress.sql /tmp
RUN service mysql start && mysql -u root mysql < /tmp/db.sql
RUN service mysql start && mysql -u root mysql < /tmp/user.sql
RUN service mysql start && mysql -u root mysql < /tmp/wordpress.sql

# install phpmyadmin
RUN tar xvfz srcs/phpMyAdmin*.tar.gz && \
	mv phpMyAdmin* var/www/localhost/phpmyadmin
	
RUN sed -i "/$cfg['blowfish_secret']/c $cfg['blowfish_secret'] = 'fWo.ELTNhwasNbXpTKz=[DR/R440007[';" /var/www/localhost/phpmyadmin/config.sample.inc.php
RUN mv /var/www/localhost/phpmyadmin/config.sample.inc.php /var/www/localhost/phpmyadmin/config.inc.php

# install wordpress
RUN tar xvfz srcs/wordpress*.tar.gz
RUN cp srcs/wp-config.php wordpress/ && \
	rm -rf wordpress/wp-config-sample.php
RUN mv wordpress/* var/www/localhost && \
	rm -rf wordpress

RUN		sed -i '/upload_max_filesize/c upload_max_filesize = 20M' /etc/php/7.3/fpm/php.ini
RUN		sed -i '/post_max_size/c post_max_size = 21M' /etc/php/7.3/fpm/php.ini

# 80: http	443: https
EXPOSE 80 443

# start up nginx, mysql and php inside image
CMD service mysql restart && \
	service php7.3-fpm start && \
	nginx -g 'daemon off;'
