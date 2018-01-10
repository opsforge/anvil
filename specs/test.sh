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
curl --data build=true -X POST 'https://registry.hub.docker.com/u/opsforge/anvil/trigger/5f7336f8-319d-4938-8634-61726c32f4d5/'
echo "DockerHub build triggered..."
