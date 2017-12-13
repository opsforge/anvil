# opsforge stack 2.0 #

The opsforge stack v2 is an all-in-one development solution, that aims to deliver a development platform that is:
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
* can run on localhost or AWS the same way

| Project names and images | Project Health | Comments |
| --- | --- | --- |
| `opsforge/opsforge` [![](https://images.microbadger.com/badges/version/opsforge/opsforge.svg)](https://microbadger.com/images/opsforge/opsforge "Docker Hub link")  [![](https://images.microbadger.com/badges/image/opsforge/opsforge.svg)](https://microbadger.com/images/opsforge/opsforge "Get your own image badge on microbadger.com") | Build health: [ ![Codeship Status for opsforgeio/opsforge](https://app.codeship.com/projects/f6cc7410-98b5-0134-62d3-3e4a8d26d28a/status?branch=master)](https://app.codeship.com/projects/187530) Code health: [![Issue Count](https://codeclimate.com/github/opsforgeio/opsforge/badges/issue_count.svg)](https://codeclimate.com/github/opsforgeio/opsforge) | Ubuntu container with tools and shell  |
| `opsforge/shipyard` [![](https://images.microbadger.com/badges/image/opsforge/shipyard.svg)](https://microbadger.com/images/opsforge/shipyard "Get your own image badge on microbadger.com") | CI/CD: [![CircleCI](https://circleci.com/gh/opsforgeio/shipyard/tree/master.svg?style=svg)](https://circleci.com/gh/opsforgeio/shipyard/tree/master) | Docker Engine and Swarm controller, API and Web UI |
| `docker.elastic.co/logstash/logstash:6.0.1` `docker.elastic.co/elasticsearch/elasticsearch:6.0.1` `docker.elastic.co/kibana/kibana:6.0.1` | N/A | Logging and collector engine |

Components:

| Name | Purpose | Accessibility |
| ---  | ------- | ------------- |
| Cloud9 IDE | Development interface | Browser window |
| opsbox | ZSH (shell) through Butterfly, pre-built CLIs and git control | Browser window or Docker shell |
| shipyard | Docker engine access and container access | Browser window or API |
| ELK | Audit and shell logging (optional) | Browser window or API |

# Deployment

## Pre-deployment steps

## Deploying the stack

The recommended way to deploy the opsforge stack is through docker-compose. Make sure your machine has the latest version of docker engine and docker-compose installed. You can check from your command line using `docker -v` and `docker-compose -v`

Either clone this project repository to your machine using `git` or just download the `docker-compose.yaml` file from the project root to a folder on your machine, `cd` into that folder and type `docker-compose -p opsforge up -d`

# Removal

To delete the stack, simply `cd` into your project folder and type `docker-compose -p opsforge down`. Make sure you remove content from any persisted data mounts manually.

# Usage

`hostname` will be either localhost or if you deployed to another machine, the DNS record / IP for that.

| Service | Address |
| -- | -- |
| Cloud9 | http://localhost:8181 |
| opsbox (ZSH) | http://localhost:8001 |
| shipyard | http://localhost:8080 |
| Kibana | http://localhost:5601 |
| Logstash (for sending logs and metrics in) | http://localhost:5000 |
