#!/bin/bash

echo "
                  __
  ___  _ __  ___ / _| ___  _ _  __ _  ___
 / _ \| '_ \(_-<|  _|/ _ \| '_|/ _\` |/ -_)
 \\___/| .__//__/|_|  \\___/|_|  \\__, |\\___|
      |_|                      |___/
"

echo "
++ opsforge toolkit provisioner 1.0 ++

Please stand by until the components are provisioned to the base image."

echo "Pending actions:"

echo -n ">>> Updating and configuring base image..."
sudo apt-get update &>/dev/null
sudo apt-get upgrade -y &>/dev/null
sudo apt-get install zip -y &>/dev/null
echo "Done"

echo -n ">>> Fixing persistent Ubuntu locale issue..."
sudo apt-get install language-pack-en -y &>/dev/null
sudo locale-gen en_GB.UTF-8 &>/dev/null
echo "Done"

echo ">>> Deploying and configuring prerequisites:"
echo -n " - Installing GIT..."
sudo apt-get -y install git &>/dev/null
echo "Done"
echo -n " - Installing zsh.."
sudo apt-get -y install zsh &>/dev/null
echo "Done"
echo -n " - Installing JQ and Python PIP..."
sudo apt-get install jq -y &>/dev/null
sudo apt-get install python-pip -y &>/dev/null
echo "Done"

echo -n ">>> Installing and configuring Docker Engine..."
sudo /bin/zsh -c 'curl -fsSL https://get.docker.com/ | sh' &>/dev/null
sudo usermod -aG docker ubuntu &>/dev/null
sudo service docker restart &>/dev/null
echo "Done"

echo ">>> Rancher local server configration:"
echo -n " - Deploying rancher server image..."
sudo /bin/bash -c 'docker run -d -v /home/ubuntu/rancher-db:/var/lib/mysql --restart=unless-stopped -p 8080:8080 rancher/server:latest' &>/dev/null
echo "Done"

echo -n " - Querying local instance IP..."
export hostip=$(hostname -I | awk '{print $1}') &>/dev/null
echo "Retrieved"

echo -n " - Waiting for API to come online..."
while [ -z $testy ]; do
	testy=$(curl -XGET -sIL http://$hostip:8080/v1/registrationtokens | grep 'HTTP*.*200')
	sleep 5
done
echo "Online"
echo -n " - Generating registration token..."
curl -XPOST -sL http://$hostip:8080/v1/projects/1a5/registrationtokens &>/dev/null
check=""
echo "Done"
echo -n " - Retrieving new registration token..."
while [ -z $check ]; do
	check=$(curl -s -X GET http://$hostip:8080/v1/projects/1a5/registrationtokens | jq '.data[].state' | grep active)
	sleep 15
done
echo "Done"

echo -n " - Registering instance as rancher host with token..."
export token=$(curl -XGET -sL http://$hostip:8080/v1/projects/1a5/registrationtokens | jq '.data[].registrationUrl' | sed 's/\"//g')

sudo /bin/bash -c "docker run -t -d --name cattleserver \
 -e CATTLE_AGENT_IP=\"$hostip\" \
 -e CATTLE_HOST_LABLES='type=localresource' \
 --privileged -v /var/run/docker.sock:/var/run/docker.sock \
 -v /var/lib/rancher:/var/lib/rancher rancher/agent:latest $token" &>/dev/null
echo "Done"

echo -n " - Waiting 30 seconds for container cleanup..."
sleep 30
sudo /bin/bash -c 'docker rm $(docker ps -a -q)' &>/dev/null
echo "Done"

echo -n " - Registering public opsforge catalog..."
curl -XPUT http://$hostip:8080/v1/activesettings/1as\!catalog.url -sL -H 'localhost:8080' -H 'Accept: application/json' -H 'Content-Type: application/json' \
-d @- << EOF
{
"activeValue": "community=https://git.rancher.io/community-catalog.git,library=https://git.rancher.io/rancher-catalog.git",
"id": "1as!catalog.url",
"name": "catalog.url",
"source": "Default Environment Variables",
"value": "community=https://git.rancher.io/community-catalog.git,opsforge=https://github.com/opsforgeio/opsforge.git,library=https://git.rancher.io/rancher-catalog.git"
}
EOF &>/dev/null
echo "Done"


echo ">>> Setting custom Message of the Day:"
echo "
                  __
  ___  _ __  ___ / _| ___  _ _  __ _  ___
 / _ \| '_ \(_-<|  _|/ _ \| '_|/ _\` |/ -_)
 \\___/| .__//__/|_|  \\___/|_|  \\__, |\\___|
      |_|                      |___/

opsforge version 1.0 - 2016 - LIC Apache 2.0" | sudo tee /etc/motd.tail &>/dev/null
echo " - Done"

echo "

No actions left. Provisiong successful. You can reach the services from
http://localhost:8080 or via ssh by 'vagrant ssh opsforge'. For documentation
please read the GitHub readme."
