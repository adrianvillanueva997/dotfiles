#!/bin/sh
cp kitty /home/${USER}/.config/
cp .ssh /home/${USER}/
cp .tmux.conf /home/${USER}/
cp fish /home/${USER}/.config

sudo apt update && sudo apt install -y tmux fish git neofetch 

echo "Installing docker!"

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo "Installing VsCode!"

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gnupg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code

echo "Installing rust!"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Installing neovim!"

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
git clone https://github.com/kabinspace/AstroVim ~/.config/nvim
nvim +PackerSync
echo "Installing fisher!"

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install

echo "Instaling golang!"

sudo add-apt-repository ppa:longsleep/golang-backports 
sudo apt update
sudo apt install golang-go



