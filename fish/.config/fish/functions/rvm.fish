function rvm --description "Ruby Version Manager"
	exec bash --login -c "[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" && rvm $argv; exec fish"
end
