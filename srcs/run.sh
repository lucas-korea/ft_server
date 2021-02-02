#!/bin/bash

service mysql start
echo "CREATE DATABASE IF NOT EXISTS wordpress;" | mysql -u root --skip-password
echo "CREATE USER IF NOT EXISTS 'cjung'@'localhost' IDENTIFIED BY '1234';" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'cjung'@'localhost' WITH GRANT OPTION;"| mysql -u root --skip-password

service nginx start
service php7.3-fpm start

bash
