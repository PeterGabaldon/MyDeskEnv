#! /bin/bash

# Pedro Gabaldon (PeterG11)
# https://petergabaldon.github.io/

if [ $EUID -ne 0 ];
then
  echo "I should be run as root, sorry :("
  exit 1
fi

# Clone repo to get config files
git clone https://github.com/PeterGabaldon/MyDeskEnv.git ~/MyDeskEnv

export DEBIAN_FRONTEND=nointeractive
echo "Updating apt cache..."
apt update

# First, install zsh and make it default shell
echo "Ok, I will install zsh and make it default first"
apt install zsh
chsh -s $(which zsh)

echo "Getting powerlevel10k theme for zsh"
# Get P10K
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

echo "Installing zsh plugins..."
# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh-syntax-highlighting
git clone https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo/sudo.plugin.zsh /usr/share/zsh-sudo

# Bat and bat-extras
echo "Installing bat, the cat clone with wings :P, and bat-extras"
apt install bat

git clone https://github.com/eth-p/bat-extras.git ~/bat-extras
~/bat-extras/install.sh

# lsd
echo "Installing lsd..."
wget -qP ~/ https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb
dpkg -i ~/lsd_0.20.1_amd64.deb

# tpm
echo "Installing tpm"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Remember to press Ctrl+a and the I in a tmux session to install it"

# Sublime text
echo "Installing sublime text"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
apt-get install apt-transport-https

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt update
apt install sublime-text

# Install HackNerd font
unzip ~/MyDeskEnv/Hack.zip -d /usr/share/fonts

# Move config files
echo "Copying all config files..."
cd ~/MyDeskEnv/
cp -a .p10k.zsh .tmux.conf .vimrc .zshrc .vim -t ~/

echo "I will the system reboot in 5 seconds"
sleep 5 && reboot
