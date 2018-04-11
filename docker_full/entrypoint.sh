#!/bin/zsh

while [ $# -gt 0 ]; do
  case "$1" in
    --fullname=*)
      fullname="${1#*=}"
      ;;
    --myemail=*)
      myemail="${1#*=}"
      ;;
    --pastebinurl=*)
      pastebinurl="${1#*=}"
      ;;
    --giturlwithcred=*)
      giturlwithcred="${1#*=}"
      ;;
    --btpass=*)
      btpass="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

# ChefDK is temporarily removed
# # Eval chef in current session
# eval "$(chef shell-init zsh)"

shellsource() {
  # Set up shellsource with Rancher attributue
  if [ $3 ]; then
    git clone --no-checkout $3 ~/home.tmp
    mv -f ~/home.tmp/.git ~/
    rm -rf ~/home.tmp
    cd ~
    git reset --hard HEAD
    chmod 0600 ~/.ssh/id_*
  fi
  git config --global user.name $1
  git config --global user.email $2
}

butterfly-up() {
  echo "root:${btpass:-password}" | chpasswd
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
shellsource ${fullname} ${myemail} ${giturlwithcred}
repos ${pastebinurl}
butterfly-up
