# .bashrc

# Source global definitions
if [[ -f /etc/bashrc ]]; then
	. /etc/bashrc
fi

case $- in
    *l*) FISHFLAGS=-l;;
    *i*) FISHFLAGS=-i;;
    *)   FISHFLAGS=  ;;
esac

if which fish > /dev/null 2>&1 && [[ -t 0 || -p /dev/stdin ]]; then
    exec fish ${FISHFLAGS}
fi

# User specific aliases and functions {{{
export PATH="~/bin:$PATH"
trysource() {
	for i; do
		[[ -f $i ]] && source $i # || echo "$i not found"
	done
}

function up {
    local ups="."
    for((i=0;i<${1:-1};i++)); do
		ups="${ups}/.."
	done
	cd "$ups"
}

vim() {
	if which nvim > /dev/null 2>&1; then
		nvim "$@"
	elif which vim > /dev/null 2>&1; then
		command vim "$@"
	else
		vi "$@"
	fi
}

alias ls='command ls --color=auto'

prompt_pwd() {
    case "$PWD" in
        "$HOME")
            echo "~"
            ;;
        *)
            printf "%s" $(echo $PWD|sed -e "s|^$HOME|~|" -e 's-/\(\.\{0,1\}[^/]\)\([^/]*\)-/\1-g')
            echo "$PWD" | sed -n -e 's-.*/\.\{0,1\}.\([^/]*\)-\1-p'
            ;;
    esac
}
# }}}

# Prompt {{{
# Setup {{{
shiftput() {
    tput enacs && printf "$(tput smacs)$1$(tput rmacs)" || printf "$2"
}
PR_HBAR="$(shiftput q "-")"
PR_ULCORNER="$(shiftput l "+")"
PR_LLCORNER="$(shiftput m "+")"
PR_LRCORNER="$(shiftput j "+")"
PR_URCORNER="$(shiftput k "+")"
COLORNAMES=(BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE)
for index in ${!COLORNAMES[@]}; do
    eval color="${COLORNAMES[$index]}"
    eval "PR_$color='$(tput setaf $index)'"
    eval "PR_LIGHT_$color='$(tput setaf $(expr $index + 8))'"
done
PR_NO_COLOR="$(tput sgr0)"
PR_BODY_COLOR="${PR_NO_COLOR}${PR_LIGHT_CYAN}"
# }}}

# Prompt configuration
typeset -a _prc_modules
_prc_modules=( userhost time smiley pwd git )

function setprompt() {
    local ret=$?
    eval $(resize)
    _prc_userhost="${PR_RED}$(whoami)${PR_YELLOW}@$(hostname)"
    _prc_time="${PR_WHITE}$(date +"%H:%m:%S")"
    _prc_smiley="$([[ $ret == 0 ]] && echo "${PR_LIGHT_GREEN}^_^" || echo "${PR_LIGHT_RED}O_O [$ret]")"
    _prc_pwd="${PR_YELLOW}$(prompt_pwd)"
    # Git prompt {{{
    if source git-prompt.sh 2>/dev/null; then
        GIT_PS1_SHOWDIRTYSTATE=0
        GIT_PS1_SHOWSTASHSTATE=1
        GIT_PS1_SHOWUNTRACKEDFILES=0
        #GIT_PS1_DESCRIBE_STYLE="branch"
        GIT_PS1_SHOWUPSTREAM="auto git"
        GIT_PS1_HIDE_IF_PWD_IGNORED=1
        _prc_git="$(__git_ps1 "${PR_LIGHT_MAGENTA}%s")"
    fi
    # }}}
    # Now actually print
    echo -ne "${PR_BODY_COLOR}${PR_ULCORNER}"
    for mod in ${_prc_modules[@]}; do
        if eval "test -n \"\${_prc_$mod}\""; then
            echo -ne "${PR_BODY_COLOR}${PR_HBAR}[${PR_NO_COLOR}"
            eval echo -ne "\${_prc_$mod}"
            echo -ne "${PR_BODY_COLOR}]${PR_NO_COLOR}"
        fi
    done
    echo
}
export PROMPT_COMMAND=
export PS1='$(setprompt)\n\[${PR_BODY_COLOR}\]${PR_LLCORNER}\]>\[${PR_NO_COLOR}\] '
# }}}

trysource ~/.bashrc.local

# vim: et fdm=marker