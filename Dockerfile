# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: ldideric <ldideric@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/09 00:02:37 by nben-ezr      #+#    #+#                  #
#    Updated: 2020/06/24 17:39:14 by ldideric      ########   odam.nl          #
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

RUN         wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz && \
            tar xzfv phpMyAdmin-5.0.1-english.tar.gz -C /root && \
            mkdir /var/www/html/phpmyadmin && \
            cp -a /root/phpMyAdmin-5.0.1-english/. /var/www/html/phpmyadmin/ && \
            rm -rf root/phpMyAdmin-5.0.1-english && \
            rm -rf phpMyAdmin-5.0.1-english.tar.gz && \
            mv /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

# install wordpress
#RUN tar xvfz srcs/*.tar.gz
#RUN cp srcs/wp-config.php wordpress/
#RUN mv wordpress var/www/localhost

RUN service mysql stop && service mysql start && \
    mysql < /var/www/html/phpmyadmin/sql/create_tables.sql -u root && \
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'ldideric'@'localhost' IDENTIFIED BY 'admin' WITH GRANT OPTION;FLUSH PRIVILEGES;" && \
    mysql -e "CREATE DATABASE wordpress;GRANT ALL PRIVILEGES ON wordpress.* TO 'ldideric'@'localhost' IDENTIFIED BY 'admin';FLUSH PRIVILEGES;" && \
    chmod 660 /var/www/html/phpmyadmin/config.inc.php

RUN         wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN			chmod +x wp-cli.phar
RUN 		mv wp-cli.phar /usr/local/bin/wp
RUN			wp core download --allow-root --path=var/www/html
COPY		srcs/wp-config.php var/www/html/
RUN			service mysql restart
RUN			wp core install --allow-root --url=localhost --path=/var/www/html --title=Wordpress --admin_user=ldideric \
			--admin_password=wachtwoord --admin_email=ldideric@student.codam.nl --skip-email

# connecting SQL to PHP
#RUN pecl install sqlsrv pdo_sqlsrv

# generate SSL certificate
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt;

#CONFIGRE MYSQL DATABASE
#RUN         service mysql start && \
#			echo "create user 'ldideric'@'localhost' identified by 'wachtwoord'" | mysql -u root && \
##			echo "grant all privileges on *.* to 'ldideric'@'localhost';" | mysql -u root && \
#			echo "flush privileges;" | mysql -u root

#80: http	110: sendmail	443: https
EXPOSE 80 110 443

# start up nginx, mysql and php inside image
CMD service nginx start && \
	service mysql restart && \
	service php7.3-fpm start && \
	tail -f /dev/null
