# .bashrc

if [ ! -z $PS1 ]; then
	fish; exit
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
