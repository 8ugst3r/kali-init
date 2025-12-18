#!/bin/bash

cat << "EOF"

welcome

██████╗ ██╗   ██╗ ██████╗ ███████╗████████╗███████╗██████╗
██╔══██╗██║   ██║██╔════╝ ██╔════╝╚══██╔══╝██╔════╝██╔══██╗
██████╔╝██║   ██║██║  ███╗███████╗   ██║   █████╗  ██████╔╝
██╔══██╗██║   ██║██║   ██║╚════██║   ██║   ██╔══╝  ██╔══██╗
██████╔╝╚██████╔╝╚██████╔╝███████║   ██║   ███████╗██║  ██║

EOF

# SYSTEM

## git setup
ssh-keygen -t ed25519 -C "8ugst3.r@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
ssh-add -l
git config --global user.name "8ugst3r"
git config --global user.email "8ugst3.r@gmail.com"
cat ~/.ssh/id_ed25519.pub

read -p "Set key on your github.com and continue with Enter..."

## setup notes and automatic pull
git clone git@github.com:8ugst3r/notes.git ~/git

sudo touch /var/log/note-update.log
sudo chown root:adm /var/log/note-update.log
sudo chmod 664 /var/log/note-update.log

sudo tee /usr/local/bin/notes-update.sh > /dev/null <<'EOF'
#!/bin/bash
/usr/bin/git pull -C ~/git/notes >> /var/log/note-update.log 2>&1
EOF
sudo chmod 755 /usr/local/bin/notes-update.sh

sudo tee /etc/cron.d/notes-update <<EOF
# Pull latest notes on every boot
@reboot $(whoami) /usr/local/bin/notes-update.sh
EOF

# APPS

## chrome
sudo apt update && sudo apt upgrade -y && sudo apt install wget ca-certificates curl -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

## discord
sudo apt install wget gdebi-core
wget "https://discordapp.com/api/download?platform=linux&format=deb" -O discord.deb
sudo gdebi discord.deb

sudo apt install zim
