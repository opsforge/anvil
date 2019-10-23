You will need Python PIP installed so if you don't have that, follow https://pip.pypa.io/en/stable/installing/

1. Follow the Linux distro's instructions you have on https://docs.docker.com/install/
2. Open your terminal
3. Type `pip install docker-compose` and press Enter
4. Open the ANViL git repo on https://github.com/opsforge/anvil
5. If you have GIT installed on your Mac, clone the project
6. If you don't have GIT, download in a ZIP and extract to your preferred location
7. Either way, in your terminal `cd` into the folder you have ANViL in
8. Use the bootstrapper to start up the stack with the following command: `./anvil.sh`

That's the install done.

You can stop and terminate ANViL containers any time using `./anvil.sh --destroy` from the ANViL project folder.

Some ANViL containers persist data on the host using mounts, this is so that you can see / back-up / restore / delete the data they keep easily
without having to deal with Docker volumes. If you are using the project in GIT mode and are making commits, these are excluded by the
`.gitignore` file by default. If for some reason you want to keep them in GIT (not one to judge), you can comment out the ignores.