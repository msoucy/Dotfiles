function man -d "Colored manpage display"
	# Currently broken?
	# from http://pastie.org/pastes/206041/text
	set -x LESS_TERMCAP_mb (set_color -o red)
	set -x LESS_TERMCAP_md (set_color -o red)
	set -x LESS_TERMCAP_me (set_color normal)
	set -x LESS_TERMCAP_se (set_color normal)
	set -x LESS_TERMCAP_so (set_color -b blue -o yellow)
	set -x LESS_TERMCAP_ue (set_color normal)
	set -x LESS_TERMCAP_us (set_color -o green)
	set -x PAGER less
	set -x LESS -FR
	/usr/bin/man $argv
end
