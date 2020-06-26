# .bashrc
# shellcheck shell=bash

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

if [[ -z "$PS1" ]]; then
    return
fi

export HISTCONTROL=ignoreboth:erasedups

# User specific aliases and functions {{{
export PATH="$HOME/bin:$PATH"
trysource() {
    for i; do
        [[ -f $i ]] && source "$i" # || echo "$i not found"
    done
}

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

prompt_pwd() {
    case "$PWD" in
        "$HOME")
            echo "~"
            ;;
        *)
            printf "%s" "$(echo "$PWD"|sed -e "s|^$HOME|~|" -e 's-/\(\.\{0,1\}[^/]\)\([^/]*\)-/\1-g')"
            echo "$PWD" | sed -n -e 's-.*/\.\{0,1\}.\([^/]*\)-\1-p'
            ;;
    esac
}

export PIPENV_VENV_IN_PROJECT=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
# }}}

# Prompt {{{
# Setup {{{
PR_HBAR="$(printf '\u2500')"
PR_ULCORNER="$(printf '\u250c')"
PR_LLCORNER="$(printf '\u2514')"
PR_LRCORNER="$(printf '\u2510')"
PR_URCORNER="$(printf '\u2518')"
COLORNAMES=(BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE)
typeset -A PR_COLOR
for index in "${!COLORNAMES[@]}"; do
    color="${COLORNAMES[$index]}"
    PR_COLOR["$color"]="\033[0;$((30 + "index"))m"
    PR_COLOR["LIGHT_$color"]="\033[0;$((90 + "index"))m"
done
PR_COLOR[NONE]="\033[0m"
PR_COLOR[BODY]="${PR_COLOR[NONE]}${PR_COLOR[LIGHT_CYAN]}"
export GIT_PS1_SHOWDIRTYSTATE=0
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=0
#export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWUPSTREAM="auto git"
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
source /usr/share/doc/git/contrib/completion/git-prompt.sh 2>/dev/null
# }}}

# Prompt configuration
typeset -a _prc_modules
_prc_modules=( userhost time smiley pwd git venv )
typeset -A _prc_moddata
_prc_moddata[userhost]="${PR_COLOR[RED]}$(whoami)${PR_COLOR[YELLOW]}@$(hostname)"

setprompt () {
    local ret=$?
    _prc_moddata[time]="${PR_COLOR[WHITE]}$(date +"%H:%M:%S")"
    _prc_moddata[smiley]="$([[ $ret == 0 ]] && echo "${PR_COLOR[LIGHT_GREEN]}^_^" || echo "${PR_COLOR[LIGHT_RED]}O_O [$ret]")"
    _prc_moddata[pwd]="${PR_COLOR[YELLOW]}$(prompt_pwd)"
    # Git prompt {{{
    if type -t __git_ps1 > /dev/null 2>&1; then
        _prc_moddata[git]="$(__git_ps1 "${PR_COLOR[LIGHT_MAGENTA]}%s")"
    else
        _prc_moddata[git]=""
    fi
    # }}}
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        _prc_moddata[venv]="${PR_COLOR[BLUE]}$(basename "${VIRTUAL_ENV}")"
    else
        _prc_moddata[venv]=""
    fi
    # Now actually print
    echo -ne "${PR_COLOR[BODY]}${PR_ULCORNER}"
    for mod in "${_prc_modules[@]}"; do
        if test -n "${_prc_moddata[$mod]}"; then
            echo -ne "${PR_COLOR[BODY]}${PR_HBAR}[${PR_COLOR[NONE]}${_prc_moddata[$mod]}${PR_COLOR[BODY]}]${PR_COLOR[NONE]}"
        fi
    done
    echo
}
export PROMPT_COMMAND=
export PS1="\$(setprompt)\012\[${PR_COLOR[BODY]}\]${PR_LLCORNER}>\[${PR_COLOR[NONE]}\] "
# }}}

trysource ~/.bashrc.local ~/.local/bashrc

test -f "${HOME}/.dircolors" && eval "$(dircolors -b "$HOME/.dircolors")"
test -f ~/.fzf.bash && source ~/.fzf.bash

: # Just so that the shell starts with a non-error code

# vim: et fdm=marker
