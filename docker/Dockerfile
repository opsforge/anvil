# Dockerfile of opsforge.io DevUtils for PaaS use - Copyright (C) 2017 George Svachulay - Apache 2.0 License

FROM ubuntu:16.04

MAINTAINER opsforge.io
LABEL name="opsforge"
LABEL version="1.0.0"

EXPOSE 5757

VOLUME /root/repos

# OS fixes and additions

USER root
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install zip language-pack-en -y && \
    locale-gen en_GB.UTF-8 && \
    apt-get clean

# Tooling

RUN apt-get -y install git zsh curl wget nano telnet dnsutils jq python-pip python-dev libsqlite3-dev libffi-dev libssl-dev netcat sshpass inetutils-ping && \
    pip install awscli && \
    apt-get clean

RUN pip install libsass
RUN pip install butterfly

RUN cd /tmp && \
    if [ -f "chefdk.deb" ]; then \
      dpkg -i chefdk.deb ; \
    else \
      curl -L -o chefdk.deb 'https://packages.chef.io/stable/ubuntu/12.04/chefdk_1.0.3-1_amd64.deb' ; \
      dpkg -i chefdk.deb \
    ;fi && \
    curl -L -o cfinst.deb https://cli.run.pivotal.io/stable\?release\=debian64\&source\=github && \
    dpkg -i cfinst.deb && \
    rm cfinst.deb

# ZSH setup and terminal broadcasting

RUN rm -rf ~/.git && \
    cd ~ && \
    rm -rf ~/.oh-my-zsh && \
    bash -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k && \
    mkdir -p /etc/butterfly/themes/powerlevel9k && \
    curl -fsSL -o /etc/butterfly/themes/powerlevel9k/style.sass 'http://pastebin.com/raw/CmHwxw2W' && \
    chmod 0755 /etc/butterfly/themes/powerlevel9k/style.sass

COPY entrypoint.sh /root/entrypoint.sh

RUN chmod 0755 /root/entrypoint.sh

SHELL ["/bin/zsh", "-c"]
CMD ["/root/entrypoint.sh"]
