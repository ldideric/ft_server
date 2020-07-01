# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: ldideric <ldideric@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/09 00:02:37 by nben-ezr      #+#    #+#                  #
#    Updated: 2020/07/01 18:30:30 by ldideric      ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

LABEL maintainer="Lietze Diderich ldideric"

# update
RUN apt-get update -y && \
	apt-get upgrade -y && \
# install requirements
	apt-get install -y \
	wget \
	nginx \
	mariadb-server mariadb-client \
	php php-cli php-fpm php-cgi php-mysql php-mbstring php-pear \
	openssl \
	mcrypt && \
	rm -rf /var/lib/apt/lists/*

# Adding all sources to the image
COPY srcs srcs
RUN mkdir -p var/www/localhost && \
	chmod +x srcs/autoindex.sh && \
# generate SSL certificate
	openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt && \
# copying localhost config file to nginx folder
	cp srcs/localhost /etc/nginx/sites-available/localhost && \
	ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost && \
# install mysql
	mv srcs/user.sql srcs/db.sql srcs/wordpress.sql srcs/create_tables.sql /tmp && \
	service mysql start && mysql -u root mysql < /tmp/db.sql && \
	service mysql start && mysql -u root mysql < /tmp/user.sql && \
	service mysql start && mysql -u root mysql < /tmp/wordpress.sql && \
	service mysql start && mysql -u root mysql < /tmp/create_tables.sql && \
# install phpmyadmin
	tar xvfz srcs/phpMyAdmin*.tar.gz && \
	mv phpMyAdmin* var/www/localhost/phpmyadmin && \
	cat /var/www/localhost/phpmyadmin/config.sample.inc.php | sed "s/.*blowfish_secret.*/\$cfg\[\'blowfish_secret\'\]\ \=\ \'fWo\.ELTNhwasNbXpTKz\=\[DR\/R440007\[\'\;/" > /var/www/localhost/phpmyadmin/config.sample.inc.php.tmp && mv /var/www/localhost/phpmyadmin/config.sample.inc.php.tmp /var/www/localhost/phpmyadmin/config.sample.inc.php && \
	mv /var/www/localhost/phpmyadmin/config.sample.inc.php /var/www/localhost/phpmyadmin/config.inc.php && \
# install wordpress
	tar xvfz srcs/wordpress*.tar.gz && \
	cp srcs/wp-config.php wordpress/ && \
	rm -rf wordpress/wp-config-sample.php && \
	mv wordpress/* var/www/localhost && \
	rm -rf wordpress && \
# edit max uploade size
	sed -i '/upload_max_filesize/c upload_max_filesize = 20M' /etc/php/7.3/fpm/php.ini && \
	sed -i '/post_max_size/c post_max_size = 21M' /etc/php/7.3/fpm/php.ini 

# 80: http	443: https
EXPOSE 80 443

# start up nginx, mysql and php inside image
CMD service mysql restart && \
	service php7.3-fpm start && \
	nginx -g 'daemon off;'
