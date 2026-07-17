#!/usr/bin/env bash

set -e  # fail if any line fails

(
  # Ghost only officially supports MySQL 8 in production - MariaDB isn't
  # supported and has real behavioral differences (e.g. MySQL 8 changed
  # utf8mb4's own default collation, which MariaDB never did, breaking FK
  # constraints on any new table Ghost creates that references an older
  # column - see https://docs.ghost.org/faq/supported-databases). Use the
  # official mysql image (not mysql/mysql-server, which has historically had
  # native ARM64 issues) to match production and catch these locally.
  docker run --rm --detach -p 3306:3306 --name edo-ghost-db --env MYSQL_USER=testuser --env MYSQL_PASSWORD=testpassword --env MYSQL_ROOT_PASSWORD=rootpassword --env MYSQL_DATABASE="everydotorgblog" mysql:8.4
)
