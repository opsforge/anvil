#!/bin/zsh

FULLNAME=$1
MYEMAIL=$2
PASTEBINURL=$3
GITURLWITHCRED=$4


# Eval chef in current session
eval "$(chef shell-init zsh)"

shellsource() {
  # Set up shellsource with Rancher attributue
  if [ $GITURLWITHCRED ]; then
    git clone --no-checkout $1 ~/home.tmp
    mv -f ~/home.tmp/.git ~/
    rm -rf ~/home.tmp
    cd ~
    git reset --hard HEAD
    chmod 0600 ~/.ssh/id_*
    source ~/.zshrc
  fi
  git config --global user.name $2
  git config --global user.email $3
}

butterfly-up() {
  butterfly.server.py --host="0.0.0.0" --port=5757 --unsecure
}

repos() {
  curl -fsSL -o /tmp/repos.conf $1
  chmod 0755 /tmp/repos.conf

  cd ~/repos

  echo "Cloning repos, please wait..."
  while read repox; do
    echo ">>> Retrieving $repox repo."
    git clone $repox &>/dev/null
    echo ">>> Done."
  done </tmp/repos.conf
}

# Actions to be done

cd /root
shellsource ${GITURLWITHCRED} ${FULLNAME} ${MYEMAIL}
repos ${PASTEBINURL}
butterfly-up
