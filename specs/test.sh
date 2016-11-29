echo "Initiating tests..."
chmod -R 0777 ./
echo ">>> Docker Lints:"
./specs/generic.spec.sh
if [ $? -eq 0 ]; then
  echo ">>> Docker Lints concluded and none failed."
else
  echo ">>> Tests failed."
  exit 1
fi
echo "Initiating DockerHub builds..."
curl --data build=true -X POST 'https://registry.hub.docker.com/u/opsforge/opsforge/trigger/ee46ac63-b47a-4fc6-a9e2-6718d52ebda7/'
echo "DockerHub build triggered..."
