function uhex
	cat /dev/urandom | hexdump | sed -E "s/([A-Fa-f0-9])([A-Fa-f0-9]{6}) (.*)/\1x\2: \3 /g"
end
