#!/usr/bin/env bash

sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.4 php8.4-mbstring php8.4-curl php8.4-phpdbg php8.4-xdebug -y

echo

php -v
