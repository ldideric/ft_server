# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: ldideric <ldideric@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/09 00:02:37 by nben-ezr      #+#    #+#                  #
#    Updated: 2020/06/15 22:57:44 by ldideric      ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

LABEL maintainer="Lietze Diderich ldideric"

# update
RUN apt-get update -y && \
	apt-get upgrade -y

# install tools
RUN apt-get install wget -y

# copying sources to docker image
ADD srcs/localhost /etc/nginx/sites-available/localhost

# install nginx
RUN apt-get install nginx -y

# install SQL
RUN apt-get install mariadb-server -y && \
	apt-get install mariadb-client -y

# php libraries
RUN apt-get update && apt-get install -y \
	php7.0 \
#libapache2-mod-php7.0 \
	mcrypt \
#php7.0-mcrypt \
	php-mbstring \
	php-pear \
#php7.0-dev \
	--no-install-recommends && \
	rm -rf /var/lib/apt/lists/*

# connecting SQL to PHP
#RUN pecl install sqlsrv pdo_sqlsrv

RUN mkdir wordpress_temp
COPY srcs/wordpress-5.3.2-nl_NL.tar.gz wordpress_temp

RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt; 

# install wordpress
RUN tar xvfz ./wordpress_temp/*

#80: http		443: https
EXPOSE 80 443

CMD service nginx start && \
	service mysql start && \
#tail -f /dev/null