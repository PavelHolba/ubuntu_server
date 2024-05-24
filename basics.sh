#!/bin/bash

# Exit immediately if any command fails
set -e

# Clear the terminal screen for clean output
clear

# Print a header indicating the start of the provisioning routine
echo
echo "## Provisioning New Ubuntu Linux Server (Basic) ##"
echo

# Update package lists
sudo apt-get update

# Perform distribution upgrade for handling changes in dependencies
sudo apt-get dist-upgrade -y

# Upgrade installed packages
sudo apt-get upgrade -y

# Install essential network utilities
sudo apt-get install -y net-tools


# Print a message indicating the completion of the provisioning routine
echo
echo "## Provisioning Completed Successfully ##"
echo
