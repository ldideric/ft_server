# OPERATING SYSTEM
FROM         debian:buster
# AUTHOR
MAINTAINER     Aristotelis Bobas <abobas@student.codam.nl>
# COPY SOURCE FILES
COPY        srcs/. /root/
# INSTALL PACKAGES
RUN         apt-get update && \
			apt-get install -y apt-utils nginx php-fpm php-gd php-mbstring wget php-mysql mariadb-server
# CONFIGURE SSL CERTIFICATES
RUN         wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 && \
			chmod 777 ./mkcert-v1.1.2-linux-amd64 && \
			./mkcert-v1.1.2-linux-amd64 localhost && \
			rm -rf ./mkcert-v1.1.2-linux-amd64 && \
			mv ./localhost.pem ./etc/nginx && \
			mv ./localhost-key.pem ./etc/nginx
# CONFIGURE NGINX WEB SERVER
RUN         mv /root/info.php /var/www/html && \
			mv /root/index.html /var/www/html && \
			mv /root/index.sh . && \
			mv /root/nginx.conf /etc/nginx/sites-available && \
			ln -fs /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled && \
			nginx -t
# CONFIGRE MYSQL DATABASE
RUN         service mysql start && \
			echo "create user 'abobas'@'localhost' identified by 'wachtwoord'" | mysql -u root && \
			echo "create database wordpress;" | mysql -u root && \
			echo "grant all privileges on *.* to 'abobas'@'localhost';" | mysql -u root && \
			echo "flush privileges;" | mysql -u root
# CONFIGURE PHPMYADMIN DASHBOARD
RUN         wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz && \
			tar xzfv phpMyAdmin-5.0.1-english.tar.gz -C /root && \
			mkdir /var/www/html/phpmyadmin && \
			cp -a /root/phpMyAdmin-5.0.1-english/. /var/www/html/phpmyadmin/ && \
			rm -rf root/phpMyAdmin-5.0.1-english && \
			rm -rf phpMyAdmin-5.0.1-english.tar.gz && \
			mv /root/config.inc.php /var/www/html/phpmyadmin/
# CONFIGURE WORDPRESS
RUN            wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \    
			chmod +x wp-cli.phar && \
			mv wp-cli.phar /usr/local/bin/wp && \
			wp core download --allow-root --path=var/www/html && \
			mv /root/wp-config.php /var/www/html && \
			service mysql restart && \
			wp core install --allow-root --url=localhost --path=/var/www/html --title=Wordpress --admin_user=abobas \
			--admin_password=wachtwoord --admin_email=abobas@student.codam.nl --skip-email
# GRANT PERMISSIONS
RUN         chown -R www-data:www-data /var/www/* && \
			chmod -R 755 /var/www/*
# START SERVICES
CMD         service mysql restart && service php7.3-fpm start && nginx -g 'daemon off;'