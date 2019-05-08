#
# autoload/functions.sh
#

if [[ "${OSTYPE}" == 'darwin'* ]]; then
  restart_coreaudio() {
    sudo kill "$(ps -ax | grep 'coreaudiod' | grep 'sbin' |awk '{print $1}')"
  }

  restart_nix_docker() {
    sudo -v
    docker rm -f nix-docker-remote-builder
    ssh-add -K
    sudo -E nix-agentd
    sudo -E nix-remote-agent
  }
fi

# Hides .desktop file
deskhide() {
  grep -q '^NoDisplay' $1 && sed -i 's/^NoDisplay.*/NoDisplay=true/' $1 \
    || echo 'NoDisplay=true' >> $1
}

# Launches .desktop file from terminal
deskopen() {
  $(grep '^Exec' $1 | tail -1 | sed 's/^Exec=//' | sed 's/%.//') &
}

# Makes .desktop file visible
deskshow() {
  grep -q '^NoDisplay' $1 && sed -i 's/^NoDisplay.*/NoDisplay=false/' $1 \
    || echo 'NoDisplay=false' >> $1
}

# Support .bashrc reloading
dotfiles() {
  if echo "$@" | grep -q 'reload'; then
    source ~/.bashrc
  fi

  command dotfiles $@
}

# Colorized man pages
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}
