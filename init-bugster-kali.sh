#!/bin/bash

# chrome
sudo apt update && sudo apt upgrade -y && sudo apt install wget ca-certificates curl -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

# discord
sudo apt install wget gdebi-core
wget "https://discordapp.com/api/download?platform=linux&format=deb" -O discord.deb
sudo gdebi discord.deb

sudo apt install zim
