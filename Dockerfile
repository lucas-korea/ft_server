FROM	debian:buster

LABEL	maintainer="cjung@student.42seoul.kr"

RUN	apt-get update && apt-get install -y \
	nginx \
	mariadb-server \
	php-mysql \
	php-mbstring \
	openssl \
	vim \
	wget \
	php7.3-fpm

COPY	./srcs/run.sh ./
COPY	./srcs/default ./tmp
COPY	./srcs/wp-config.php ./tmp
COPY	./srcs/config.inc.php ./tmp

# chmod
RUN chmod 775 /run.sh
RUN chown -R www-data:www-data /var/www/
RUN chmod -R 755 /var/www/

# open ssl
RUN openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Lee/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
RUN mv localhost.dev.crt etc/ssl/certs/
RUN mv localhost.dev.key etc/ssl/private/
RUN chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key

# nginx
RUN rm /etc/nginx/sites-available/default
RUN cp -rp /tmp/default /etc/nginx/sites-available/

# wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
RUN mv wordpress/ var/www/html/
RUN chown -R www-data:www-data /var/www/html/wordpress
RUN cp -rp ./tmp/wp-config.php /var/www/html/wordpress

# phpMyAdmin and chmod
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
RUN tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
RUN mv phpMyAdmin-5.0.2-all-languages phpmyadmin
RUN mv phpmyadmin /var/www/html/
RUN rm phpMyAdmin-5.0.2-all-languages.tar.gz
RUN cp -rp /tmp/config.inc.php /var/www/html/phpmyadmin/
RUN chown -R root:root /var/www/html/phpmyadmin
RUN chmod -R 707 /var/www/html/phpmyadmin
RUN chmod 705 /var/www/html/phpmyadmin/config.inc.php

EXPOSE	80 443

CMD 	bash run.sh
