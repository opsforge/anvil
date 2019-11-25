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
    --shell=*)
      shell_set="${1#*=}"
      ;;
    --proxy)
      proxy="true"
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
  if [ $1 ] ; then
    butterfly.server.py --host="0.0.0.0" --port=5757 --unsecure --i_hereby_declare_i_dont_want_any_security_whatsoever
  else
    butterfly.server.py --host="0.0.0.0" --port=5757 --unsecure
  fi
}

# consul-join() {
#   consul_if=$(getent hosts consul | cut -d ' ' -f 1 | cut -d '.' -f1-2 | cut -d ' ' -f3)
#   consul_addr=$(ip addr | grep $consul_if | grep inet | sed 's/.*inet.//' | sed 's/\ brd.*//' | sed 's/\/.*//')
#   mkdir -p /var/log/consul
#   consul agent -retry-join "consul" -bind=$consul_addr -data-dir=/etc/consul/data -datacenter=opsforge -node=anvil -config-file=/etc/consul.json >> /var/log/consul/output.log &
# }

repos() {  
  if [ $1 ]; then
  curl -fsSL -o /tmp/repos.conf $1
    chmod 0755 /tmp/repos.conf

    cd ~/repos

    echo "Cloning repos, please wait..."
    while read repox; do
      echo ">>> Retrieving $repox repo."
      git clone $repox &>/dev/null
      echo ">>> Done."
    done </tmp/repos.conf
  fi
}

change_shell() {
  if [ $1 ]; then
    chsh root -s "/bin/$1"
  fi
}

# Actions to be done

cd /root
# consul-join
shellsource ${fullname} ${myemail} ${giturlwithcred}
repos ${pastebinurl}
change_shell ${shell_set}
butterfly-up ${proxy}
