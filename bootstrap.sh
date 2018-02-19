#!/usr/bin/env bash

echo "   _____                             __                         "
echo "  /  _  \   ____  ____  ____   _____/  |_ __ _________   ____   "
echo " /  /_\  \_/ ___\/ ___\/ __ \ /    \   __\  |  \_  __ \_/ __ \  "
echo "/    |    \  \__\  \__\  ___/|   |  \  | |  |  /|  | \/\  ___/  "
echo "\____|__  /\___  >___  >___  >___|  /__| |____/ |__|    \___  > "
echo "        \/     \/    \/    \/     \/                        \/  "
echo ""
echo "       ______ _            _        _           _           "
echo "       | ___ \ |          | |      | |         (_)          "
echo "       | |_/ / | ___   ___| | _____| |__   __ _ _ _ __      "
echo "       | ___ \ |/ _ \ / __| |/ / __|  _ \ / _ | |   _ \     "
echo "       \____/|_|\___/ \___|_|\_\___|_| |_|\__,_|_|_| |_|    "
echo ""
echo " Welcome to accenture blockchain sandbox builder, the bootstrap phase! "
echo " This will take a long time. Seriously."
sleep 4
################################################################################
###								General										 ###
################################################################################
echo "#############################"
echo "General Prep (1/5)"
echo "#############################"
sleep 1
# Update / upgrade everything for starters
sudo apt-get update

# Set up NTP service for time sync
sudo apt-get --yes --force-yes install ntp

################################################################################
###								Security									 ###
################################################################################
echo "#############################"
echo "General Secutity (2/5)"
echo "#############################"
sleep 1
# Setup Uncomplicated Firewall (UFW) to lock down access
sudo apt-get install --yes --force-yes ufw
sudo ufw allow ssh
sudo ufw default deny incoming
sudo ufw --force enable

# Allow VNC connections through the firewall
sudo ufw allow 5900:5901/tcp

# Allow ports you will need
sudo ufw allow 4200/tcp
#composer
sudo ufw allow 3000/tcp
sudo ufw allow 3100/tcp
#explorer
sudo ufw allow 8080/tcp
#couch
sudo ufw allow 5984/tcp
#peers
sudo ufw allow 7050/tcp
sudo ufw allow 7051/tcp
sudo ufw allow 7052/tcp
sudo ufw allow 7053/tcp
sudo ufw allow 7054/tcp

#ethereum ports
#sudo ufw allow 30303/udp
#sudo ufw allow 8545/tcp

#Zcash
#sudo ufw allow 8233/tcp
#sudo ufw allow 8232/tcp

################################################################################
###									Docker									 ###
################################################################################
echo "#############################"
echo "Adding Docker (3/5)"
echo "#############################"
sleep 1
# Check that legacy Docker is not running / installed
sudo apt-get --yes --force-yes remove docker docker-engine

# Grab these for aufs storage drivers
sudo apt-get --yes --force-yes \
 install linux-image-extra-virtual

# Check all pre-requisites present
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add correct repository from Docker
# WARNING: Don't use the Ubuntu / Docker repo version, it's broken
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update

# Install Docker
sudo apt-get --yes --force-yes install docker-ce docker-compose

#no sudo for docker
sudo groupadd docker
sudo gpasswd -a $USER docker



################################################################################
###									Node.js								 	 ###
################################################################################
echo "#############################"
echo "Add Node.JS and Apache (4/5)"
echo "#############################"
sleep 1
# Install Node.js v6.x
# WARNING: Do not install from Ubuntu / Debian repos
cd ~
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get --yes --force-yes install nodejs build-essential apache2

sudo ufw allow 'Apache Full'

sudo service apache2 restart

################################################################################
###									Node.js								 	 ###
################################################################################
echo "#############################"
echo "Add composer stuff (5/5)"
echo "#############################"
sleep 1

# composer
npm install -g composer-cli

# generator
npm install -g generator-hyperledger-composer

# rest server
npm install -g composer-rest-server

#yoeman
npm install -g yo
