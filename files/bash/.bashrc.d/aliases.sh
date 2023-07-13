# .bashrc
# shellcheck shell=bash

up() {
    local ups="."
    for((i=0;i<${1:-1};i++)); do
        ups="${ups}/.."
    done
    cd "$ups" || return
}

vim() {
    if which nvim > /dev/null 2>&1; then
        nvim "$@"
    elif which vim > /dev/null 2>&1; then
        command vim "$@"
    else
        command vi "$@"
    fi
}

if which nvim > /dev/null 2>&1; then
    export EDITOR=nvim
elif which vim > /dev/null 2>&1; then
    export EDITOR=vim
else
    export EDITOR=vi
fi

alias ls='command ls --color=auto'

# vim: et fdm=marker
