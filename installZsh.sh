#!/bin/bash

#1. Install curl
sudo apt install curl

#2. Install zsh
echo "Installing zsh"
sudo apt install zsh
echo "Installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "Installing starship"
sudo apt install fonts-powerline
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
echo "adding eval \"$(starship init zsh)\" to .zshrc"
echo -e "\n\n#use starship as theme" >> $HOME/.zshrc
echo -e "eval \"$(starship init zsh)\"" >> $HOME/.zshrc
echo "setting zsh as default shell"
chsh -s $(which zsh)
echo "Logout and log back in to have the default shell be zsh"
exec zsh
