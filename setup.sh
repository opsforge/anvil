#!/bin/bash

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
sudo usermod -aG docker ubuntu &>/dev/null
sudo service docker restart &>/dev/null
echo "--- Deployed Docker ---"

sudo /bin/bash -c 'docker run -d -v /home/ubuntu/rancher-db:/var/lib/mysql --restart=unless-stopped -p 8080:8080 rancher/server:v1.2.0-pre4-rc14'

export hostip=$(hostname -I | awk '{print $1}')

echo ">>> Waiting for API to come online..."
while [ -z $testy ]; do
	testy=$(curl -XGET -sIL http://$hostip:8080/v1/registrationtokens | grep 'HTTP*.*200')
	sleep 5
done
echo ">>> Generating registration token..."
curl -XPOST -sL http://$hostip:8080/v1/projects/1a5/registrationtokens
check=""
echo ">>> Retrieving token state..."
while [ -z $check ]; do
	check=$(curl -s -X GET http://$hostip:8080/v1/projects/1a5/registrationtokens | jq '.data[].state' | grep active)
	sleep 15
done

echo ">>> Registering local container as host..."
export token=$(curl -XGET -sL http://$hostip:8080/v1/projects/1a5/registrationtokens | jq '.data[].registrationUrl' | sed 's/\"//g')

sudo /bin/zsh -c "docker run -t -d --name cattleserver \
 -e CATTLE_AGENT_IP=\"$hostip\" \
 -e CATTLE_HOST_LABLES='type=localresource' \
 --privileged -v /var/run/docker.sock:/var/run/docker.sock \
 -v /var/lib/rancher:/var/lib/rancher rancher/agent:latest $token"

 sleep 30

 docker rm $(docker ps -a -q)
