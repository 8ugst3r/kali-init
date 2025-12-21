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
mkdir -p ~/git
git clone git@github.com:8ugst3r/notes.git ~/git/notes

### prepare file for logs
sudo touch /var/log/note-update.log
sudo chown root:adm /var/log/note-update.log
sudo chmod 666 /var/log/note-update.log

### prepare scripts for git pull
sudo tee /usr/local/bin/notes-update.sh > /dev/null <<'EOF'
#!/bin/bash
LOGFILE=/var/log/note-update.log
REPO=/home/bugster/git/notes

sleep 30

grep -q "^github.com " ~/.ssh/known_hosts || ssh-keyscan github.com >> ~/.ssh/known_hosts
eval $(ssh-agent -s)
ssh-add /home/bugster/.ssh/id_rsa

echo "=== git pull attempted at $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$LOGFILE"
/usr/bin/git -C "$REPO" pull >> "$LOGFILE" 2>&1

EOF

sudo chmod 755 /usr/local/bin/notes-update.sh

### set cron to run update script
sudo tee /etc/cron.d/notes-update <<EOF
# Pull latest notes on every boot
@reboot $(whoami) /usr/local/bin/notes-update.sh
EOF

# APPS

## others
sudo apt install vim zim tmux curl

## kitty
sudo apt install kitty
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50
sudo update-alternatives --config x-terminal-emulator

mkdir -p /home/bugster/Pictures
mkdir -p ~/.config/kitty
curl -L https://i.ibb.co/RpzfymVS/image.png -o /home/bugster/Pictures/terminal-background.png
cat >> /home/bugster/.config/kitty/kitty.conf <<'EOF'
background_image /home/bugster/Pictures/terminal-background.png
background_image_opacity 0.25
background_opacity 0.9
background_image_scale fill
EOF


## chrome
sudo apt update && sudo apt upgrade -y && sudo apt install wget ca-certificates curl -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

## discord
sudo apt install wget gdebi-core
wget "https://discordapp.com/api/download?platform=linux&format=deb" -O discord.deb
sudo gdebi discord.deb

## vs code
sudo apt update && sudo apt install -y wget gpg && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list && sudo apt update && sudo apt install -y code


