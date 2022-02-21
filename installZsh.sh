#!/bin/bash

#4. Install zsh
echo "Installing zsh"
sudo apt install zsh
echo "Installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Installing starship"
sudo apt install fonts-powerline
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
echo "adding eval \"$(starship init zsh)\" to .zshrc"
echo -e "\n\n#use starship as theme" >> $HOME/.zshrc
echo -e "eval \"$(starship init zsh)\"" >> $HOME/.zshrc