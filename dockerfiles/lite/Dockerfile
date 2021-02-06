# Dockerfile of opsforge.io DevUtils for PaaS use - Copyright (C) 2017 George Svachulay - Apache 2.0 License

FROM ubuntu:20.04

MAINTAINER opsforge.io
LABEL name="anvil"
LABEL version="2.2.0"
LABEL type="lite"

EXPOSE 5757

VOLUME /root/repos

# OS fixes and additions

USER root
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install zip language-pack-en -y && \
    locale-gen en_GB.UTF-8 && \
    apt-get clean

# Ubuntu package installs

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
      git \
      zsh \
      curl \
      wget \
      nano \
      telnet \
      dnsutils \
      jq \
      # python-pip \
      # python-dev \
      libsqlite3-dev \
      libffi-dev \
      libssl-dev \
      netcat \
      iproute2 \
      sshpass \
      inetutils-ping \
      vim \
      git-crypt \
      unzip \
      pwgen \
      groff \
      python3 \
      python3-pip \
    && \
    apt-get clean

# PIP package installs

RUN pip3 install libsass && \
    pip3 install butterfly

# ZSH setup and terminal broadcasting

RUN rm -rf ~/.git && \
    cd ~ && \
    rm -rf ~/.oh-my-zsh && \
    bash -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k && \
    cd ~/.oh-my-zsh/custom/themes && \
    wget "https://raw.githubusercontent.com/haribo/omz-haribo-theme/master/haribo.zsh-theme"
COPY .zshrc /root/.zshrc
RUN chmod 0755 /root/.zshrc

# Set up butterfly SASS and powerlevel9k + console themes

COPY style.sass /etc/butterfly/themes/powerlevel9k/style.sass
RUN mkdir -p /etc/butterfly/themes/powerlevel9k && \
    chmod 0755 /etc/butterfly/themes/powerlevel9k/style.sass

COPY console /etc/butterfly/themes/console
RUN chmod -R 0755 /etc/butterfly/themes/console

# Config entrypoint

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod 0755 /root/entrypoint.sh

# Config consul.json

# COPY consul.json /etc/consul.json
# RUN chmod 0755 /etc/consul.json

SHELL ["/bin/zsh", "-c"]
CMD ["/root/entrypoint.sh"]
