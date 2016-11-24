#!/bin/Bash

echo "--- Updating base OS image ---"
sudo apt-get update &>/dev/null
sudo apt-get upgrade -y &>/dev/null
sudo apt-get install zip -y &>/dev/null

echo "--- Fixing locale ---"
sudo apt-get install language-pack-en -y &>/dev/null
sudo locale-gen en_GB.UTF-8 &>/dev/null

echo "--- Generic Runlist ---"
echo "Installing Oh My ZSH with Zsh and Git prerequisites..."
sudo apt-get -y install git &>/dev/null
sudo apt-get -y install zsh &>/dev/null
echo "Installing Python PIP and AWS CLI..."
sudo apt-get install jq -y &>/dev/null
sudo apt-get install python-pip -y &>/dev/null

echo "--- Deploying Docker ---"
sudo /bin/zsh -c 'curl -fsSL https://get.docker.com/ | sh' &>/dev/null
sudo usermod -aG docker vagrant &>/dev/null
sudo service docker restart &>/dev/null
echo "--- Deployed Docker ---"

echo "--- Deploying Shipyard ---"
sudo /bin/zsh -c 'curl -sSL https://shipyard-project.com/deploy | bash -s' &>/dev/null
echo "--- Deployed Shipyard ---"

sudo /bin/bash -c 'docker run -d -v /home/vagrant/rancher-db:/var/lib/mysql --restart=unless-stopped -p 8080:8080 rancher/server:v1.2.0-pre4-rc14'
