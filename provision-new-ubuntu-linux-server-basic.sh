#!/bin/bash

set -e

reset;clear;

echo
echo "## "
echo "## routine: [provision-new-ubuntu-linux-server-basic] // state: [starting]"
echo "## "
echo

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

apt-get install -y net-tools
apt-get install -y docker-compose
apt-get install sysstat vnstat iotop iftop bwm-ng htop munin


echo
echo "## "
echo "## routine: [provision-new-ubuntu-linux-server-basic] // state: [completed]"
echo "## "
echo
