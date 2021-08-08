#! /bin/bash

# Pedro Gabaldon (PeterG11)
# https://petergabaldon.github.io/

if [ $EUID -ne 0 ];
then
  echo "I should be run as root, sorry :("
  exit 1
fi

# Clone repo to geit config files
git clone https://github.com/PeterGabaldon/MyDeskEnv.git "/home/$SUDO_USER/MyDeskEnv"

echo "Sudo will ask for password when needed (I suppose current user is a sudoer)"

export DEBIAN_FRONTEND=nointeractive
echo "Updating apt cache..."
apt update

# First, install zsh and make it default shell
echo "Ok, I will install zsh and make it default first"
apt install zsh
chsh -s $(which zsh) "$SUDO_USER"

echo "Getting powerlevel10k theme for zsh"
# Get P10K
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "/home/$SUDO_USER/powerlevel10k"

echo "Installing zsh plugins..."
# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh-syntax-highlighting

wget -qP "/usr/share/zsh-sudo/sudo.plugin.zsh" "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh"

# Bat and bat-extras
echo "Installing bat, the cat clone with wings :P, and bat-extras"
wget -qP "/home/$SUDO_USER/" "https://github.com/sharkdp/bat/releases/download/v0.18.2/bat_0.18.2_amd64.deb"
dpkg -i "/home/$SUDO_USER/bat_0.18.2_amd64.deb"

git clone https://github.com/eth-p/bat-extras.git "/home/$SUDO_USER/bat-extras"
"/home/$SUDO_USER/bat-extras/build.sh" --install

# lsd
echo "Installing lsd..."
wget -qP "/home/$SUDO_USER/" "https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb"
dpkg -i "/home/$SUDO_USER/lsd_0.20.1_amd64.deb"

# tpm
echo "Installing tpm"
git clone https://github.com/tmux-plugins/tpm "/home/$SUDO_USER/.tmux/plugins/tpm"

echo "Remember to press Ctrl+a and then I in a tmux session to install the nord theme"

# Sublime text
echo "Installing sublime text"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
apt install apt-transport-https

echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list
apt update
apt install sublime-text

# Install HackNerd font
unzip "/home/$SUDO_USER/MyDeskEnv/Hack.zip" -d "/usr/share/fonts"

# Move config files
echo "Copying all config files..."
cd "/home/$SUDO_USER/MyDeskEnv/"
cp -a .p10k.zsh .tmux.conf .vimrc .zshrc .vim -t "/home/$SUDO_USER/"
ln -sf "/home/$SUDO_USER/.vim" "/home/$SUDO_USER/.config/nvim"
ln -sf "/home/$SUDO_USER/.vimrc" "/home/$SUDO_USER/.config/nvim/init.vim"
chown -R "$SUDO_USER:$SUDO_USER" "/home/$SUDO_USER/.p10k.zsh" "/home/$SUDO_USER/.tmux.conf" "/home/$SUDO_USER/.vimrc" "/home/$SUDO_USER/.zshrc" "/home/$SUDO_USER/.vim" "/home/$SUDO_USER/.tmux"

# Change background
sudo -u "$SUDO_USER" gsettings set org.mate.background picture-filename "/home/$SUDO_USER/MyDeskEnv/background.jpg"

echo "I will reboot the system now..."
sleep 3 && reboot
