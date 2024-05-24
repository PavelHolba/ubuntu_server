#!/bin/bash

set -e

reset;clear;

echo
echo "## "
echo "## routine: [apache install] // state: [starting]"
echo "## "
echo

sudo apt update
sudo apt install apache2

sudo a2enmod ssl
sudo a2enmod headers

sudo apt install certbot python3-certbot-apache
sudo certbot --apache

echo
echo "## "
echo "## routine: [apache install] // state: [completed]"
echo "## "
echo
