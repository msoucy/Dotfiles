#!/usr/bin/zsh

################################################################################
# Make it so that we can use $ZDOTDIR
################################################################################

export ZDOTDIR=${ZDOTDIR:=$HOME}
fpath=(${ZDOTDIR}/.config/zsh/functions $fpath)

# History settings {{{

HISTFILE=~/.zhist
HISTSIZE=1000
SAVEHIST=1000

# }}}

# {{{ ZSH options

setopt NO_append_history
setopt auto_cd
setopt auto_list
setopt NO_beep
setopt NO_bsd_echo
setopt NO_chase_links
setopt complete_aliases
setopt extended_glob
setopt hist_ignore_all_dups
setopt interactive_comments
setopt multios
setopt notify
setopt numeric_glob_sort
setopt NO_nomatch
setopt path_dirs
setopt prompt_subst
setopt share_history
setopt zle
bindkey -e
# }}}

# Autocomplete {{{

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

# }}}

# Plugins {{{
# ZSH plugins
autoload -Uz compinit && compinit
autoload -U colors && colors
autoload zsh/terminfo
autoload -Uz vcs_info
autoload -U zmv
#autoload -U zsh-mime-setup && zsh-mime-setup
autoload -U edit-command-line
autoload -U promptinit && promptinit
autoload -U zrecompile
zmodload zsh/regex
# }}}

# Custom Functions {{{

# utility functions {{{
autoload -Uz check_com
autoload -Uz xsource
alias source=xsource
# }}}

# Autoload functions {{{
# grep for running process, like: 'any vim'
autoload -Uz any

# Create PDF file from source code
autoload -Uz makereadable

# Checks whether a regex matches or not.\\&\quad Example: \kbd{regcheck '.\{3\} EUR' '500 EUR'}
autoload -Uz regcheck

# List files which have been accessed within the last {\it n} days, {\it n} defaults to 1
autoload -Uz accessed

# List files which have been changed within the last {\it n} days, {\it n} defaults to 1
autoload -Uz changed

# List files which have been modified within the last {\it n} days, {\it n} defaults to 1
autoload -Uz modified

# }}}

# power completion - abbreviation expansion {{{
# power completion / abbreviation expansion / buffer expansion
# see http://zshwiki.org/home/examples/zleiab for details
# less risky than the global aliases but powerful as well
# just type the abbreviation key and afterwards ',.' to expand it
declare -A abk
abk=(
#   key   # value                  (#d additional doc string)
#A# start
    'BG'   '& exit'
    'C'    '| wc -l'
    'Hl'   ' --help |& less -r'    #d (Display help in pager)
    'R'    '| tr A-z N-za-m'       #d (ROT13)
    'SL'   '| sort | less'
    'S'    '| sort -u'
    'V'    '|& vim -'
#A# end
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

# Tweak some default settings
alias -g please='sudo'
alias ls="ls --color=auto"
alias make="make -s"
alias cp="scp"
export LESS="-F -R"

# LS color highlighting
[[ -f ~/.dircolors ]] && eval $(dircolors -b ~/.dircolors)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Move up N directories
up() {
  upstr="."
  for i in $(seq 1 $1); do
    upstr="$upstr/.."
  done
  cd $upstr
}

# }}}

autoload -U is-at-least
autoload -Uz prompt_msoucy_setup
prompt msoucy

# Keybindings {{{

# Allow C-xC-e to edit the current command line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

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
# }}}

# ZLE {{{
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
# }}}

export EDITOR=vim
source $ZDOTDIR/.zshlocal

# zgen (Packages) {{{
source ${ZDOTDIR}/.config/zsh/zgen/zgen.zsh

if ! zgen saved; then
  # Syntax highlighting
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line root)
  zgen load zsh-users/zsh-syntax-highlighting

  # oh-my-zsh plugins{{{
  zgen oh-my-zsh plugins/misc           # Misc basic aliases
  zgen oh-my-zsh plugins/common-aliases # Normal aliases
  zgen oh-my-zsh plugins/colored-man    # Colored Manpages
  # zgen oh-my-zsh plugins/profiles       # Look for custom user profiles
  zgen oh-my-zsh plugins/screen         # GNU Screen configuration
  # zgen oh-my-zsh plugins/ssh-agent      # SSH agent
  zgen oh-my-zsh plugins/sudo           # <Esc><Esc> prepends sudo
  zgen oh-my-zsh plugins/tmux           # TMUXinator
  zgen oh-my-zsh plugins/tmuxinator     # TMUXinator
  # }}}

  # Languages {{{
  zgen oh-my-zsh plugins/rvm               # Ruby Version Manager
  zgen oh-my-zsh plugins/virtualenv        # Virtualenv management
  #zgen oh-my-zsh plugins/virtualenvwrapper # And virtualenvwrapper management
  # }}}

  zgen save
fi
# }}}

# vim: fdm=marker et ts=2 sw=2

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
