#!/bin/zsh
set -e
source ~/.zshrc

#1. update apt
echo updating apt
sudo apt update

wslQuestion() {
while true; do
		read yn"?$1 [1 or 2]: "
		case $yn in
		[1]* ) $2; break;;
		[2]* ) $3; break;;
		* ) echo "Please answer 1 or 2.";;
		esac
	done

}

copyWindowsSSHKeys () {
    read username"?What is your windows username?: "
    cp -r /mnt/c/Users/$username/.ssh ~/
    chmod 600 ~/.ssh/id_ed25519
    echo copied ssh keys to ~/.ssh
}

createSshKeys() {
    read email"?What is your github email?: "

    ssh-keygen -t ed25519 -C $email
    cat ~/.ssh/id_ed25519.pub

    echo "please put the key in Github"
    while true; do
        read yn"?$1 Waiting for the key to be put in Github. Are you ready to continue? [yes] to continue: "
        case $yn in
        [yes]*) break ;;
        *) echo "Please answer yes to continue" ;;
        esac
    done
}

#2. Create or copy ssh keys for github
wslQuestion "What would you like to do? 1. Copy keys from Windows into wsl? 2. Create new keys?" copyWindowsSSHKeys createSshKeys

#3. Install Ranger
echo "Installing ranger"
sudo apt install ranger

#4 Install dot files

#5 Install NVM
echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.zshrc
echo nvm version $(nvm -v)
nvm install-latest-npm
echo node version $(nvm ls)

#6 Install Yarn
echo "Installing yarn"
npm install --global yarn
echo yarn Version: $(yarn -v)

#7 Install Python
echo "Install python3"
sudo apt install python3.8 python3-pip

#8 Install ruby
echo "Install ruby"
https://www.how2shout.com/linux/how-to-install-rvm-ruby-version-manager-on-ubuntu-20-04-lts/
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable
source ~/.zshrc
rvm --version
rvm install ruby
rvm list
read rubyVersion"?What version of ruby would you like to be default?"
rvm alias create default $rubyVersion
echo "if the following gems do not install correctly then add this to your .zshrc"
echo "[[ -s \"$HOME/.rvm/scripts/rvm\" ]] && . \"$HOME/.rvm/scripts/rvm\""
echo "Search for all installed gems with: cat \"thisfile\" | grep \"gem install\""
gem install colorize
gem install solargraph
gem install rubocop

#9 Install mysql
echo "Installing mysql"
sudo apt install mysql-server
mysql --version

#10 Install mongodb
echo "Install mongodb"
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt install -y mongodb-org
mongod --version
mkdir -p ~/data/db
sudo mongod --dbpath ~/data/db
ps -e | grep 'mongod'
curl https://raw.githubusercontent.com/mongodb/mongo/master/debian/init.d | sudo tee /etc/init.d/mongodb >/dev/null
sudo chmod +x /etc/init.d/mongodb
sudo service mongodb start
mongo --eval 'db.runCommand({ connectionStatus: 1 })'
sudo service mongodb stop
