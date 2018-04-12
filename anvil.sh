#!/bin/bash

components=""

while [ $# -gt 0 ]; do
  case "$1" in
    --cloud9)
      # cloud9="true"
      components="$components cloud9"
      ;;
    --concourse)
      # concourse="true"
      components="$components concourse"
      ;;
    --elk)
      # elk="true"
      components="$components elk"
      ;;
    --guac)
      # guac="true"
      components="$components guac"
      ;;
    --portainer)
      # portainer="true"
      components="$components portainer"
      ;;
    --splunk)
      # splunk="true"
      components="$components splunk"
      ;;
    --destroy)
      destroy="true"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

# echo $components

which docker &>/dev/null
if [ $? -ne 0 ] ; then
  echo "Missing Docker"
  exit 1
fi

which docker-compose &>/dev/null
if [ $? -ne 0 ] ; then
  echo "Missing Docker Compose"
  exit 1
fi

if echo $destroy | grep true &>/dev/null ; then
  clear
  echo "Destroy action requested."
  docker-compose -p anvil down --remove-orphans
  exit 0
fi

clear
echo "ANViL quickstart: "
echo "You requested the following components:"
echo "$components"
echo "A docker-compose.yaml file will be placed"
echo "in the current folder and started."
echo ""
echo ""

echo "Pre-deploy steps:"
echo -n "ELK fix..."
mkdir -p ./es_data &>/dev/null
chmod -R 777 ./es_data &>/dev/null
echo "Done"
echo -n "Splunk fix..."
mkdir -p ./splunk-data &>/dev/null
touch ./splunk-data/splunk-launch.conf &>/dev/null
echo "Done"


cat ./composer/header.yaml > ./docker-compose.yaml

for i in $components ; do
  cat ./composer/${i}.yaml >> ./docker-compose.yaml
done

cat ./composer/footer.yaml >> ./docker-compose.yaml

docker-compose -p anvil up -d --remove-orphans

if [ $? -eq 0 ] ; then
  echo ""
  echo "ANViL successfully started."
else
  echo ""
  echo "ANViL startup failed."
fi
