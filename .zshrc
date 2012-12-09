#!/usr/bin/sh
# Lines configured by zsh-newuser-install
HISTFILE=~/.zhist
HISTSIZE=1000
SAVEHIST=1000
setopt autocd notify sharehistory histignorealldups
unsetopt appendhistory beep extendedglob nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*' original true

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

zstyle ':completion:*' completer _expand _complete _correct _approximate

#zstyle ':completion:*' menu select=1 eval "$(dircolors -b)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' substitute 0

zstyle ':completion:*:correct:::' max-errors 1

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle '*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6-)

# SSH Completion
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show 

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Run compinstall again:
#autoload -Uz zsh-newuser-install
#zsh-newuser-install -f

setopt promptsubst prompt_subst completealiases

autoload -U colors && colors
autoload zsh/terminfo
autoload -Uz vcs_info

################################################################################
# Taken from Ryan's zshrc
################################################################################

# utility functions {{{
# this function checks if a command exists and returns either true
# or false. This avoids using 'which' and 'whence', which will
# avoid problems with aliases for which on certain weird systems. :-)
# Usage: check_com [-c|-g] word
#   -c  only checks for external commands
#   -g  does the usual tests and also checks for global aliases
check_com() {
    emulate -L zsh
    local -i comonly gatoo

    if [[ $1 == '-c' ]] ; then
        (( comonly = 1 ))
        shift
    elif [[ $1 == '-g' ]] ; then
        (( gatoo = 1 ))
    else
        (( comonly = 0 ))
        (( gatoo = 0 ))
    fi

    if (( ${#argv} != 1 )) ; then
        printf 'usage: check_com [-c] <command>\n' >&2
        return 1
    fi

    if (( comonly > 0 )) ; then
        [[ -n ${commands[$1]}  ]] && return 0
        return 1
    fi

    if   [[ -n ${commands[$1]}    ]] \
      || [[ -n ${functions[$1]}   ]] \
      || [[ -n ${aliases[$1]}     ]] \
      || [[ -n ${reswords[(r)$1]} ]] ; then

        return 0
    fi

    if (( gatoo > 0 )) && [[ -n ${galiases[$1]} ]] ; then
        return 0
    fi

    return 1
}
# Check if we can read given files and source those we can.
xsource() {
    if (( ${#argv} < 1 )) ; then
        printf 'usage: xsource FILE(s)...\n' >&2
        return 1
    fi

    while (( ${#argv} > 0 )) ; do
        [[ -r "$1" ]] && source "$1"
        shift
    done
    return 0
}
# }}}

# grep for running process, like: 'any vim'
any() {
    emulate -L zsh
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any <keyword>" >&2 ; return 1
    else
        local STRING=$1
        local LENGTH=$(expr length $STRING)
        local FIRSCHAR=$(echo $(expr substr $STRING 1 1))
        local REST=$(echo $(expr substr $STRING 2 $LENGTH))
        ps xauwww| grep "[$FIRSCHAR]$REST"
    fi
}

# Create PDF file from source code
makereadable() {
    emulate -L zsh
    output=$1
    shift
    a2ps --medium A4dj -E -o $output $*
    ps2pdf $output
}

# Checks whether a regex matches or not.\\&\quad Example: \kbd{regcheck '.\{3\} EUR' '500 EUR'}
regcheck() {
    emulate -L zsh
    zmodload -i zsh/pcre
    pcre_compile $1 && \
    pcre_match $2 && echo "regex matches" || echo "regex does not match"
}

# List files which have been accessed within the last {\it n} days, {\it n} defaults to 1
accessed() {
    emulate -L zsh
    print -l -- *(a-${1:-1})
}

# List files which have been changed within the last {\it n} days, {\it n} defaults to 1
changed() {
    emulate -L zsh
    print -l -- *(c-${1:-1})
}

# List files which have been modified within the last {\it n} days, {\it n} defaults to 1
modified() {
    emulate -L zsh
    print -l -- *(m-${1:-1})
}

# power completion - abbreviation expansion {{{
# power completion / abbreviation expansion / buffer expansion
# see http://zshwiki.org/home/examples/zleiab for details
# less risky than the global aliases but powerful as well
# just type the abbreviation key and afterwards ',.' to expand it
declare -A abk
setopt extendedglob
setopt interactivecomments
abk=(
#   key   # value                  (#d additional doc string)
#A# start
    '...'  '../..'
    '....' '../../..'
    'BG'   '& exit'
    'C'    '| wc -l'
    'G'    '|& grep --color=auto '
    'H'    '| head'
    'Hl'   ' --help |& less -r'    #d (Display help in pager)
    'L'    '| less'
    'LL'   '|& less -r'
    'M'    '| most'
    'N'    '&>/dev/null'           #d (No Output)
    'R'    '| tr A-z N-za-m'       #d (ROT13)
    'SL'   '| sort | less'
    'S'    '| sort -u'
    'T'    '| tail'
    'V'    '|& vim -'
#A# end
    'co'   './configure && make && sudo make install'
)

globalias() {
    emulate -L zsh
    setopt extendedglob
    local MATCH

    if (( NOABBREVIATION > 0 )) ; then
        LBUFFER="${LBUFFER},."
        return 0
    fi

    matched_chars='[.-|_a-zA-Z0-9]#'
    LBUFFER=${LBUFFER%%(#m)[.-|_a-zA-Z0-9]#}
    LBUFFER+=${abk[$MATCH]:-$MATCH}
}

zle -N globalias
bindkey ",." globalias
# }}}

# mercurial related stuff {{{
if check_com -c hg ; then
    # gnu like diff for mercurial
    # http://www.selenic.com/mercurial/wiki/index.cgi/TipsAndTricks
    #f5# GNU like diff for mercurial
    hgdi() {
        emulate -L zsh
        for i in $(hg status -marn "$@") ; diff -ubwd <(hg cat "$i") "$i"
    }

    # diffstat for specific version of a mercurial repository
    #   hgstat      => display diffstat between last revision and tip
    #   hgstat 1234 => display diffstat between revision 1234 and tip
    #f5# Diffstat for specific version of a mercurial repos
    hgstat() {
        emulate -L zsh
        [[ -n "$1" ]] && hg diff -r $1 -r tip | diffstat || hg export tip | diffstat
    }

fi # end of check whether we have the 'hg'-executable

# }}}



# ...geek moment when I did these, and I like them
alias imperio='su'
alias avada-kedavra='kill -9'
alias stupefy='bg'
alias engorgio='extract'

# Color some things and tweak settings
alias ls='ls --color=auto '
alias landslide="landslide -cr -x tables,abbr "
alias grep='egrep'
alias make="make -s"

# Reverse manpage lookup
alias gman="man -k "

# Convert all png files in a directory into svg
# TODO: convert this into a proper function
alias mksvg='for a in $(find `pwd` -type f -name "*.png"); do inkscape -z -f "$a" -l "${a%.png}.svg"; done'
function remake() {
	make clean && make
}
function warnmake() {
	make clean && make | grep "warning|error"
}

################################################################################
# PROMPT
################################################################################

# git/hg info
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' branchformat '%b'
zstyle ':vcs_info:*' formats '%s%m|%b%u%c|%0.6i'
zstyle ':vcs_info:*' get-revision true
#zstyle ':vcs_info:*' stagedstr '²'
#zstyle ':vcs_info:*' unstagedstr '¹'
zstyle ':vcs_info:*' stagedstr '[38;5;208m✔[38;5;028m'
zstyle ':vcs_info:*' unstagedstr '[38;5;231m✗[38;5;028m'
zstyle ':vcs_info:*' check-for-changes true

precmd () {
    vcs_info prompt

    # version control info
    if [[ "x$vcs_info_msg_0_" != "x" ]]; then
      PR_vcs_info="${PR_HBAR}[${PR_LIGHT_GREEN}$vcs_info_msg_0_${PR_BODY_COLOR}]"
    else
      PR_vcs_info=""
    fi

    # Deal with virtualenv stuff
    local venv_name="`basename \"$VIRTUAL_ENV\"`"
    if [[ "x$venv_name" != "x" ]] ; then
      PR_venv_name="${PR_op}%{$FG[209]%}$venv_name%{$PR_rc%}${PR_cp}"
    else
      PR_venv_name=""
    fi
}

setprompt() {
  vcs_info prompt
	###
	# See if we can use extended characters to look nicer.

	typeset -A altchar
	set -A altchar ${(s..)terminfo[acsc]}
	PR_SET_CHARSET="%{$terminfo[enacs]%}"
	PR_SHIFT_IN="%{$terminfo[smacs]%}"
	PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
	PR_HBAR=${PR_SHIFT_IN}${altchar[q]:--}${PR_SHIFT_OUT}
	PR_ULCORNER=${PR_SHIFT_IN}${altchar[l]:--}${PR_SHIFT_OUT}
	PR_LLCORNER=${PR_SHIFT_IN}${altchar[m]:--}${PR_SHIFT_OUT}
	PR_LRCORNER=${PR_SHIFT_IN}${altchar[j]:--}${PR_SHIFT_OUT}
	PR_URCORNER=${PR_SHIFT_IN}${altchar[k]:--}${PR_SHIFT_OUT}
  PR_FORKRIGHT=${PR_SHIFT_IN}${altchar[t]:--}${PR_SHIFT_OUT}
	
	autoload colors zsh/terminfo
	if [[ "$terminfo[colors]" -ge 8 ]]; then
		colors
	fi
	for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
		eval PR_LIGHT_$color='%{$terminfo[sgr0]$fg[${(L)color}]%}'
		(( count = $count + 1 ))
	done
	PR_NO_COLOR="%{$terminfo[sgr0]%}"

  PR_BODY_COLOR=$PR_LIGHT_CYAN

  PR_user_host="$PR_RED%n$PR_YELLOW@%M${PR_BODY_COLOR}"
  PR_time="$PR_WHITE%*${PR_BODY_COLOR}"
  PR_smiley="${PR_NO_COLOR}%(?.%{${PR_LIGHT_GREEN}%}^_^${PR_NO_COLOR}.%{$PR_LIGHT_RED%}O_O [%?]${PR_NO_COLOR})${PR_BODY_COLOR}"
  PR_pwd="%{$reset_color%}$PR_YELLOW%~${PR_BODY_COLOR}"

    #opening and closing parens
    PR_op="%{$PR_BODY_COLOR%}─[%{$reset_color%}"
    PR_cp="%{$PR_BODY_COLOR%}]%{$reset_color%}"

	PS1='${PR_BODY_COLOR}${PR_ULCORNER}[${PR_user_host}]${PR_HBAR}[${PR_time}]${PR_venv_name}${PR_vcs_info}${PR_NO_COLOR}
${PR_BODY_COLOR}${PR_FORKRIGHT}[${PR_pwd}]${PR_NO_COLOR}
${PR_BODY_COLOR}${PR_LLCORNER}[${PR_smiley}]>${PR_NO_COLOR} '
	PS2='${PR_BODY_COLOR}└>(\
${PR_LIGHT_GREEN}%_${PR_BODY_COLOR})\
${PR_SHIFT_IN}${PR_HBAR}${PR_SHIFT_OUT}>${PR_NO_COLOR} '
}

setprompt

# Always check the current working directory for executables
export PATH=.:$PATH

if which nano > /dev/null; then
	export EDITOR=nano
fi

# SSH with X forwarding
alias ssh-x='ssh -c arcfour,blowfish-cbc -YC'

# A handy Extract tool I found from dotfiles by algorithm
extract() {
   if [[ -z "$1" ]]; then
      print -P "usage: \e[1;36mextract\e[1;0m < filename >"
      print -P "       Extract the file specified based on the extension"
   elif [[ -f $1 ]]; then
      case ${(L)1} in
	  *.tar.bz2)  tar -jxvf $1;;
	  *.tar.gz)   tar -zxvf $1;;
	  *.bz2)      bunzip2 $1   ;;
	  *.gz)       gunzip $1   ;;
	  *.jar)      unzip $1       ;;
	  *.rar)      unrar x $1   ;;
	  *.tar)      tar -xvf $1   ;;
	  *.tbz2)     tar -jxvf $1;;
	  *.tgz)      tar -zxvf $1;;
	  *.zip)      unzip $1      ;;
	  *.Z)        uncompress $1;;
         *)          echo "Unable to extract '$1' :: Unknown extension"
      esac
   else
      echo "File ('$1') does not exist!"
   fi
}

ennervate(){
	if [[ -z "$1" ]]; then
		print -P "usage: \e[1;36mennervate\e[1;0m < process >"
		print -P "       Bring the process with that name to the foreground"
	else
		fg `jobs | grep "$1" | grep -E "\[([0-9]*)\]" -o | grep -E "([0-9]*)" -o | head -1`
	fi
}

build(){
	if [[ -f Makefile ]]; then
		make
	else
		ant
	fi
}

code-pull(){
	if [[ -d ".git" ]]; then
		git pull
	elif [[ -d ".svn" ]]; then
		svn update
	elif [[ -d ".hg" ]]; then
		hg pull -u
	else
		print -P "No known repository"
	fi
}

update-all() {
	for i in *; do
		echo "	Now checking: $i"
		cd $i
		code-pull
		cd ..
	done
}

update-all-code() {
	pushd ~/Code
	update-all
	popd
}

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

alias fact="elinks -dump randomfunfacts.com | sed -n '/^| /p' | tr -d \|"

export LESS="-F -R"

# Aliases for various computers
alias nethack='telnet nethack.csh.rit.edu'
alias skaia='ssh-x msoucy@skaia.csh.rit.edu'

# Allow C-xC-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

case $TERM in
      linux)
      bindkey "^[[2~" yank
      bindkey "^[[3~" delete-char
      bindkey "^[[5~" up-line-or-history
      bindkey "^[[6~" down-line-or-history
      bindkey "^[[1~" beginning-of-line
      bindkey "^[[4~" end-of-line
      bindkey "^E" expand-cmd-path ## C-e for expanding path of typed comman
      bindkey "^[[A" up-line-or-search ## up arrow for back-history-search
      bindkey "^[[B" down-line-or-search ## down arrow for fwd-history-search
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey " " magic-space ## do history expansion on space
      ;;
      *xterm*)
      bindkey "^[[2~" yank
      bindkey "^[[3~" delete-char
      bindkey "^[[5~" up-line-or-history
      bindkey "^[[6~" down-line-or-history
      bindkey "^[[1~" beginning-of-line
      bindkey "^[[4~" end-of-line
      bindkey "^[OH" beginning-of-line
      bindkey "^[OF" end-of-line
      bindkey "^E" expand-cmd-path ## C-e for expanding path of typed command
      bindkey "^[[A" up-line-or-search ## up arrow for back-history-search
      bindkey "^[[B" down-line-or-search ## down arrow for fwd-history-search
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey " " magic-space ## do history expansion on space
      ;;
      screen)
      bindkey "^[[2~" yank
      bindkey "^[[3~" delete-char
      bindkey "^[[5~" up-line-or-history
      bindkey "^[[6~" down-line-or-history
      bindkey "^[[A" up-line-or-search ## up arrow for back-history-search
      bindkey "^[[B" down-line-or-search ## down arrow for fwd-history-search
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1~" beginning-of-line
      bindkey "^[[4~" end-of-line
      ;;
esac

if [[ -f ~/.zshlocal ]]; then
	source ~/.zshlocal
fi

if [[ -d ~/zsh-syntax-highlighting/ ]]; then
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
	source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

