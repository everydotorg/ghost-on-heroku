#!/usr/bin/env bash

set -e  # fail if any line fails

(
  # docker run --rm --name edo-ghost-mysql --platform linux/x86_64 -e MYSQL_ROOT_PASSWORD="rootpassword" -e MYSQL_PASSWORD="testpassword" -e MYSQL_USER="testuser" -e MYSQL_DATABASE="everydotorgblog" -d -p 3306:3306 mysql/mysql-server:8.0 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
  # docker run --rm --name edo-ghost-mysql --platform linux/x86_64 -e MYSQL_ROOT_PASSWORD="rootpassword" -e MYSQL_PASSWORD="testpassword" -e MYSQL_USER="testuser" -e MYSQL_DATABASE="everydotorgblog" -d -p 3306:3306 mysql/mysql-server:8.0 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
  docker run --rm --detach -p 3306:3306 --name edo-ghost-db --env MARIADB_USER=testuser --env MARIADB_PASSWORD=testpassword --env MARIADB_ROOT_PASSWORD=rootpassword --env MARIADB_DATABASE="everydotorgblog" mariadb:10.7.4
)
