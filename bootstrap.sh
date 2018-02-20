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
function systemPrep(){
echo "#############################"
echo "General Prep"
echo "#############################"
sleep $CLI_DELAY
# Update / upgrade everything for starters
sudo apt-get update

# Set up add everything here
sudo apt-get --yes --force-yes install ntp
}
################################################################################
###								Security									 ###
################################################################################
function portSetter(){
echo "#############################"
echo "General Secutity"
echo "#############################"
sleep $CLI_DELAY
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
sudo ufw allow 30303/udp
sudo ufw allow 8545/tcp

#Zcash
sudo ufw allow 8233/tcp
sudo ufw allow 8232/tcp
}
################################################################################
###									Docker									 ###
################################################################################
function addDocker(){
echo "#############################"
echo "Adding Docker"
echo "#############################"
sleep $CLI_DELAY
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
}
################################################################################
###									Print the usage message								 	 ###
################################################################################

function printHelp () {
  echo "Usage: "
  echo "  bootstrap.sh -s -m up|down|restart|generate [-c <channel name>] [-t <timeout>] [-d <delay>] [-f <docker-compose-file>] [-s <dbtype>]"
  echo "  bootstrap.sh -h|--help (print this message)"
  echo "    -s <system> - initial build of one of 'fab <fabric>', 'jpm <quorum>', 'eth <ethereum>'"
  echo "    -t <timeout> - CLI timeout duration in microseconds (defaults to 10000)"
}

# Ask user for confirmation to proceed
function askProceed () {
  read -p "Continue (y/n)? " ans
  case "$ans" in
    y|Y )
      echo "proceeding ..."
    ;;
    n|N )
      echo "exiting..."
      exit 1
    ;;
    * )
      echo "invalid response"
      askProceed
    ;;
  esac
}
################################################################################
###									Node.js								 	 ###
################################################################################
function addNode(){
echo "#############################"
echo "Add Node.JS and Apache "
echo "#############################"
sleep $CLI_DELAY
# Install Node.js v6.x
# WARNING: Do not install from Ubuntu / Debian repos
cd ~
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get --yes --force-yes install nodejs build-essential apache2

sudo ufw allow 'Apache Full'

sudo service apache2 restart
}
################################################################################
###									Node.js								 	 ###
################################################################################

function buildFabric(){
echo "#############################"
echo "Add fabric stuff"
echo "#############################"
sleep $CLI_DELAY

# composer
npm install -g composer-cli

# generator
npm install -g generator-hyperledger-composer

# rest server
npm install -g composer-rest-server

#yoeman
npm install -g yo

}


################################################################################
###									All the real code								 	 ###
################################################################################

# Obtain the OS and Architecture string that will be used to select the correct
# native binaries for your platform
OS_ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
# timeout duration - the duration the CLI should wait for a response from
# another container before giving up
CLI_TIMEOUT=10
#default for delay
CLI_DELAY=3

# Parse commandline args
while getopts "h?m:c:t:d:f:s:" opt; do
  case "$opt" in
    h|\?)
      printHelp
      exit 0
    ;;
    s) SYSTEM=$OPTARG
    ;;
    t)  CLI_TIMEOUT=$OPTARG
  esac
done

if [ "$SYSTEM" == "fabric" ]; then
  EXPMODE="Building Hyperledger Fabric sandbox"
elif [ "$SYSTEM" == "jpm" ]; then
  EXPMODE="Building JPM Quorum Sandbox"
elif [ "$SYSTEM" == "eth" ]; then
  EXPMODE="Building Ethereum(parity) Sandbox"
else
  printHelp
  exit 1
fi

# ask for confirmation to proceed
askProceed

#Create the network using docker compose
if [ "${SYSTEM}" == "fabric" ]; then
  systemPrep
  portSetter
  addDocker
  adddNode
  buildFabric
elif [ "${SYSTEM}" == "jpm" ]; then ## Clear the network
  networkDown
elif [ "${SYSTEM}" == "eth" ]; then ## Generate Artifacts

else
  printHelp
  exit 1
fi
