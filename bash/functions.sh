#
# bash/functions
#

# Colored man pages
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

# Launch .desktop files from terminal
# https://stackoverflow.com/questions/7131670/make-bash-alias-that-takes-parameter
deskopen() {
    `grep '^Exec' $1 | tail -1 | sed 's/^Exec=//' | sed 's/%.//'` &
}

# Hide .desktop file
deskhide() {
    grep -q '^NoDisplay' $1 && sed -i 's/^NoDisplay.*/NoDisplay=true/' $1 \
        || echo 'NoDisplay=true' >> $1
}

# Make .desktop file visible
deskshow() {
    grep -q '^NoDisplay' $1 && sed -i 's/^NoDisplay.*/NoDisplay=false/' \
        $1 || echo 'NoDisplay=false' >> $1
}
