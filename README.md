# opsforge ANViL

The opsforge anvil (a renaming of the opsforge stack 2.0) is an all-in-one development solution, that aims to deliver a development platform that is:
* using browser accessible web-apps (no terminal emulator or IDE needed / even on Windows)
* built on docker-native and container-based services
* structured and configured by docker-compose
* relying on OSS-only components
* swarm-compatible for scale-out needs (e.g larger dev environments)
* has in-built logging and audit (for collaboration and record keeping)
* highly customisable (modular)
* easly reproducable and replacable
* version controlled
* platform and infrastructure agnostic
* can run on localhost and AWS the same way

| Project names and images | Project Health | Comments |
| --- | --- | --- |
| `opsforge/anvil` [![](https://images.microbadger.com/badges/version/opsforge/opsforge.svg)](https://microbadger.com/images/opsforge/opsforge "Docker Hub link")  [![](https://images.microbadger.com/badges/image/opsforge/opsforge.svg)](https://microbadger.com/images/opsforge/opsforge "Get your own image badge on microbadger.com") | Build health: [ ![Codeship Status for opsforgeio/opsforge](https://app.codeship.com/projects/f6cc7410-98b5-0134-62d3-3e4a8d26d28a/status?branch=master)](https://app.codeship.com/projects/187530) Code health: [![Issue Count](https://codeclimate.com/github/opsforgeio/opsforge/badges/issue_count.svg)](https://codeclimate.com/github/opsforgeio/opsforge) | Ubuntu container with tools and shell  |
| `docker.elastic.co/logstash/logstash:6.0.1` `docker.elastic.co/elasticsearch/elasticsearch:6.0.1` `docker.elastic.co/kibana/kibana:6.0.1` | N/A | Logging and collector engine |

Components:

| Name | Purpose | Accessibility |
| ---  | ------- | ------------- |
| Cloud9 IDE | Development interface | Browser window |
| opsbox | ZSH (shell) through Butterfly, pre-built CLIs and git control | Browser window or Docker shell |
| Apache Guacamole | Remote desktop, VNC, TTY, etc access (optional) | Browser window |
| portainer | Docker engine access and container access | Browser window or API |
| ELK | Audit and shell logging (optional) | Browser window or API |

# Deployment

## Pre-deployment steps

It's recommended to create a new folder in the destination directory first. The name of the folder can be anything the OS supports.

1. `cd` into the folder you created
2. `mkdir -p ./es_data`
3. `chmod -R 777 ./es_data`

This will resolve any issues with ownership when the ES container is starting up.

## Deploying the stack

The recommended way to deploy anvil is through docker-compose. Make sure your machine has the latest version of docker engine and docker-compose installed. You can check from your command line using `docker -v` and `docker-compose -v`

Either clone this project repository to your machine using `git` or just download the `docker-compose.yaml` file from the project root to a folder on your machine, `cd` into that folder and type `docker-compose -p anvil up -d`

# Removal

To delete the stack, simply `cd` into your project folder and type `docker-compose -p anvil down`. Make sure you remove content from any persisted data mounts manually.

# Usage

`hostname` will be either localhost or if you deployed to another machine, the DNS record / IP for that.

| Service | Address |
| -- | -- |
| Cloud9 | http://localhost:8181 |
| anvil (core) | http://localhost:8001 |
| Apache Guacamole | http://localhost:8002/guacamole/ |
| portainer | http://localhost:9000 |
| Kibana | http://localhost:5601 |
| Logstash (for sending logs and metrics in) | http://localhost:5000 |

# Customization

You are free to comment out / add in parts of the docker-compose to disable or remove services on startup. You can apply your changes with a simple `docker-compose -p anvil up -d` on an active deployment.

You can also make use of portainer on port `9000`. After logging in and connecting in to the local docker engine, you can stop / start / create / remove containers on-demand through the web UI or its API.

# WIP (to-be-done)

* Guacamole doesn't play nice with private DNS servers (public records seem to be fine)
* Desktop copy/paste doesn't seem to work in Guacamole and drive sharing is flaky
* anvil container doesn't include a puppet cli yet
* Logstash doesn't support multiline TCP intake since its previous version update. A line sent to the listener remains a single line.
* Create a read-the-docs page for the project
* YouTube demo video
