#!/usr/bin/sh

################################################################################
# Make it so that we can use $ZDOTDIR
################################################################################

[ -n "${ZDOTDIR+x}" ] || export ZDOTDIR=$HOME

################################################################################
# History settings
################################################################################

HISTFILE=~/.zhist
HISTSIZE=1000
SAVEHIST=1000

################################################################################
# ZSH options
################################################################################

setopt \
        NO_append_history\
        auto_cd\
        auto_list\
        NO_beep\
        NO_bsd_echo\
        NO_chase_links\
        complete_aliases\
        extended_glob\
        hist_ignore_all_dups\
        interactive_comments\
        multios\
        notify\
        numeric_glob_sort\
        NO_nomatch\
        path_dirs\
        prompt_subst\
        share_history\
        zle
bindkey -e

################################################################################
# Autocomplete
################################################################################

# {{{ General completion technique

zstyle ':completion:*' completer _complete _prefix _ignored _complete:-extended

zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# e.g. f-1.j<TAB> would complete to foo-123.jpeg
zstyle ':completion:*:complete-extended:*' matcher-list 'r:|[._-]=** r:|=**'

# }}}
# {{{ Completion caching

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# }}}
# {{{ Expand partial paths

# e.g. /u/s/l/D/fs<TAB> would complete to
# /usr/src/linux/Documentation/fs
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# }}}
# {{{ Include non-hidden dirs in globbed file completions for certain commands

#zstyle ':completion::complete:*' \
# tag-order 'globbed-files directories' all-files
#zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# }}}
# {{{ Don't complete backup files (e.g. 'bin/foo~') as executables

zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# }}}
# {{{ Don't complete uninteresting users

zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs \
        \
        bin daemon adm lp sync shutdown halt mail uucp operator games gopher \
        ftp nobody oprofile dbus polkitd abrt rpc hsqldb saslauth colord rtkit \
        openvpn usbmuxd apache tss avahi-autoipd gdm mailnull smmsp \
        nm-openconnect backuppc rpcuser nfsnobody sshd chrony tcpdump pulse \
        qemu radvd avahi gitosis

# ... unless we really want to.
zstyle '*' single-ignored show

# }}}
# {{{ Output formatting

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# }}}
# {{{ Array/association subscripts

# When completing inside array or association subscripts, the array
# elements are more useful than parameters so complete them first:
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# }}}
# {{{ Completion for processes

zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always

# }}}

# SSH Completion
zstyle -e ':completion::*:hosts' hosts 'reply=($(sed -e "/^#/d" -e "s/ .*\$//" -e "s/,/ /g" /etc/ssh_known_hosts(N) ~/.ssh/known_hosts(N) 2>/dev/null | xargs) $(grep \^Host ~/.ssh/config(N) | cut -f2 -d\  2>/dev/null | xargs))'
#zstyle -e ':completion::*:hosts' hosts 'reply=($(grep \^Host ~/.ssh/config(N) | cut -f2 -d\  2>/dev/null | xargs))'

################################################################################
# All the plugins we want
################################################################################

# Load all the plugins we want to use
autoload -Uz compinit
compinit

autoload -U colors && colors

autoload zsh/terminfo
autoload -Uz vcs_info

autoload -U zmv

#autoload -U zsh-mime-setup
#zsh-mime-setup

autoload -U edit-command-line

autoload -U promptinit
promptinit

autoload -U zrecompile

zmodload zsh/regex

################################################################################
# All of the functions
################################################################################

fpath=(${ZDOTDIR}/.config/zsh/functions $fpath)

# utility functions {{{
autoload -Uz check_com
autoload -Uz xsource
alias source=xsource
# }}}

# grep for running process, like: 'any vim'
autoload -Uz any

# Create PDF file from source code
autoload -Uz makereadable

# Checks whether a regex matches or not.\\&\quad Example: \kbd{regcheck '.\{3\} EUR' '500 EUR'}
autoload -Uz regcheck
# List files which have been accessed within the last {\it n} days, {\it n} defaults to 1
autoload -Uz accessed

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


# Color some things and tweak settings
alias please='sudo'
alias ls='ls --color=auto'
alias landslide="landslide -cr -x tables,abbr"
alias grep='egrep'
alias make="make -s"
alias cp="scp"
export LESS="-F -R"
# Reverse manpage lookup
alias gman="man -k "

# Convert all png files in a directory into svg
mksvg() {
  for a in $(find $(pwd) -type f -name "*.png"); do
    inkscape -z -f "$a" -l "${a%.png}.svg";
  done
}

function remake() {
  make clean && make
}
function warnmake() {
  make clean && make | grep "warning|error"
}

function rot13 () {
  if (( $# == 0 ))
  then tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"
  else echo $* | tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"
  fi
}

################################################################################
# PROMPT
################################################################################

# git/hg info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' branchformat '%b'
zstyle ':vcs_info:*' formats '%s%m|%b%u%c|%0.6i'
zstyle ':vcs_info:*' get-revision true
#zstyle ':vcs_info:*' stagedstr '²'
#zstyle ':vcs_info:*' unstagedstr '¹'
zstyle ':vcs_info:*' stagedstr '%{[38;5;208m%}✔%{[22;32m%}'
zstyle ':vcs_info:*' unstagedstr '%{[38;5;231m%}✗%{[22;32m%}'
zstyle ':vcs_info:*' check-for-changes true

precmd () {
    vcs_info prompt

    # version control info
    if [[ "x$vcs_info_msg_0_" != "x" ]]; then
      PR_vcs_info="${PR_BODY_COLOR}[${PR_LIGHT_GREEN}$vcs_info_msg_0_${PR_BODY_COLOR}]${PR_HBAR}${PR_NO_COLOR}"
    else
      PR_vcs_info=""
    fi

    # Deal with virtualenv stuff
    local venv_name="`basename \"$VIRTUAL_ENV\"`"
    if [[ "x$venv_name" != "x" ]] ; then
      PR_venv_name="${PR_BODY_COLOR}[${PR_LIGHT_GREEN}$venv_name${PR_BODY_COLOR}]${PR_HBAR}${PR_NO_COLOR}"
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
  PR_HBAR="${PR_SHIFT_IN}${altchar[q]:--}${PR_SHIFT_OUT}"
  PR_ULCORNER="${PR_SHIFT_IN}${altchar[l]:--}${PR_SHIFT_OUT}"
  PR_LLCORNER="${PR_SHIFT_IN}${altchar[m]:--}${PR_SHIFT_OUT}"
  PR_LRCORNER="${PR_SHIFT_IN}${altchar[j]:--}${PR_SHIFT_OUT}"
  PR_URCORNER="${PR_SHIFT_IN}${altchar[k]:--}${PR_SHIFT_OUT}"
  PR_FORKRIGHT="${PR_SHIFT_IN}${altchar[t]:--}${PR_SHIFT_OUT}"

  for color in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$fg_bold[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg_no_bold[${(L)color}]%}'
  done
  PR_NO_COLOR="%{$reset_color%}"

  PR_BODY_COLOR=$PR_LIGHT_CYAN

  PR_user_host="${PR_RED}%n${PR_YELLOW}@%M${PR_BODY_COLOR}"
  PR_time="${PR_BODY_COLOR}[$PR_WHITE%*${PR_BODY_COLOR}]"
  PR_smiley="${PR_NO_COLOR}%(?.${PR_LIGHT_GREEN}^_^${PR_NO_COLOR}.${PR_LIGHT_RED}O_O [%?]${PR_NO_COLOR})${PR_BODY_COLOR}"
  PR_pwd="${PR_NO_COLOR}${PR_YELLOW}%~${PR_BODY_COLOR}"

  PS1='${PR_BODY_COLOR}${PR_ULCORNER}[${PR_user_host}]${PR_HBAR}[${PR_pwd}]${PR_NO_COLOR}
${PR_BODY_COLOR}${PR_LLCORNER}[${PR_smiley}]>${PR_NO_COLOR} '
  RPS1='${PR_venv_name}${PR_vcs_info}${PR_time}${PR_NO_COLOR}'
  PS2='${PR_BODY_COLOR}${PR_LLCORNER}>(\
${PR_LIGHT_GREEN}%_${PR_BODY_COLOR})\
${PR_SHIFT_IN}${PR_HBAR}${PR_SHIFT_OUT}>${PR_NO_COLOR} '
}

setprompt

# Always check the current working directory for executables
export PATH=.:$PATH

export EDITOR=vim

# SSH with X forwarding
alias ssh-x='ssh -c arcfour,blowfish-cbc -YC'

# A handy Extract tool for most common archive types
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

up() {
        if (( $# != 1 ))
        then
                cd ..
        else
                upstr="."
                for i in {1..$1}
                do
                        upstr="$upstr/.."
                done
                cd $upstr
        fi
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

man2() {
  env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[1;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
      man "$@"
}

# Alias to play Bingehack as Nethack
alias nethack='telnet nethack.csh.rit.edu'

# Allow C-xC-e to edit the current command line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# Meta-S prepends "sudo " to the command
function insert_sudo {
	if [[ $BUFFER != "sudo "* ]]; then
		BUFFER="sudo $BUFFER"; CURSOR+=5
	fi
}
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Word forward/back
export WORDCHARS='*?_[]~=&;!#$%^(){}'
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' ${terminfo[smkx]}
    }
    function zle-line-finish () {
        printf '%s' ${terminfo[rmkx]}
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

bindkey " " magic-space ## do history expansion on space

[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

[[ -f $ZDOTDIR/.zshlocal ]] && source $ZDOTDIR/.zshlocal

[[ -f $HOME/.pystartup.py ]] && export PYTHONSTARTUP=$HOME/.pystartup.py

if [[ -d $ZDOTDIR/zsh-syntax-highlighting/ ]]; then
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
  source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
