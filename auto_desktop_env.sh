#! /bin/bash

# Pedro Gabaldon (PeterG11)
# https://petergabaldon.github.io/

if [ $EUID -ne 0 ];
then
  echo "I should be run as root, sorry :("
  exit 1
fi

# Colors
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

# Clone repo to geit config files
git clone https://github.com/PeterGabaldon/MyDeskEnv.git "$HOME/MyDeskEnv"

echo "Sudo will ask for password when needed (I suppose current user is a sudoer)"

export DEBIAN_FRONTEND=nointeractive
echo "Updating apt cache..."
apt update

# First, install zsh and make it default shell
echo "Ok, I will install zsh and make it default first"
apt install zsh
chsh -s $(which zsh)

echo "Getting powerlevel10k theme for zsh"
# Get P10K
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"

echo "Installing zsh plugins..."
# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh-syntax-highlighting
git clone https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo/sudo.plugin.zsh /usr/share/zsh-sudo

# Bat and bat-extras
echo "Installing bat, the cat clone with wings :P, and bat-extras"
apt install bat

git clone https://github.com/eth-p/bat-extras.git "$HOME/bat-extras"
"$HOME/bat-extras/build.sh --install"

# lsd
echo "Installing lsd..."
wget -qP "$HOME/ https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb"
dpkg -i "$HOME/lsd_0.20.1_amd64.deb"

# tpm
echo "Installing tpm"
git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

echo "Remember to press Ctrl+a and the I in a tmux session to install it"

# Sublime text
echo "Installing sublime text"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
apt install apt-transport-https

echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list
apt update
apt install sublime-text

# Install HackNerd font
unzip "$HOME/MyDeskEnv/Hack.zip -d /usr/share/fonts"

apt install wmctrl

# Move config files
echo "Copying all config files..."
cd "$HOME/MyDeskEnv/"
cp -a .p10k.zsh .tmux.conf .vimrc .zshrc .vim -t "$HOME/"

# Change background
apt install gsettings
gsettings set org.mate.background picture-filename ""$HOME/MyDeskEnv/background.jpg""

echo "I will reboot the system now..."
sleep 3 && reboot
