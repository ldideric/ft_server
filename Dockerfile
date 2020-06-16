# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: ldideric <ldideric@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/09 00:02:37 by nben-ezr      #+#    #+#                  #
#    Updated: 2020/06/16 19:20:55 by ldideric      ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

LABEL maintainer="Lietze Diderich ldideric"

# update
RUN apt-get update -y && \
	apt-get upgrade -y

# install SQL
RUN apt-get install wget nginx mariadb-server mariadb-client php php-cli php-fpm \
	php-cgi php-mysql php-mbstring openssl mcrypt php-mbstring php-pear -y && \
	rm -rf /var/lib/apt/lists/*

RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt; 
RUN cat /etc/ssl/private/nginx-selfsigned.key

# copying sources to docker image
ADD srcs/localhost /etc/nginx/sites-enabled/localhost

# connecting SQL to PHP
#RUN pecl install sqlsrv pdo_sqlsrv

RUN mkdir wordpress_temp
COPY srcs/wordpress-5.3.2-nl_NL.tar.gz wordpress_temp

# install wordpress
RUN tar xvfz ./wordpress_temp/*

#80: http		443: https
EXPOSE 80 443

CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start