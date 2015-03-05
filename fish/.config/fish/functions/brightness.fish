function brightness
	sudo su -c "echo $argv > /sys/class/backlight/nv_backlight/brightness"
end
