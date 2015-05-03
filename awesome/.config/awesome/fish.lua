local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

fish = { state = 1, basicfish = ">})°>", revfish = "<°({<" , maxcycles = 8}
fish.fg = wibox.widget.textbox()
fish.fg:set_align("right")
fish.widget = wibox.widget.background()
fish.widget:set_widget(fish.fg)
fish.widget:set_fg("#000000")
fish.widget:set_bg("#33CCFF")

function fish.fortune()
    naughty.notify({ text = awful.util.pread("fortune -n 100 -s"), timeout = 7 })
end

--fish.states = { "<°}))o»«", "<°)})o>«", "<°))}o»<" }
fish.fg:buttons(awful.util.table.join(
	awful.button({}, 1, fish.fortune)
))

function fish.update()
    local t = ""
	local fsc = fish.state
	local fsh = fish.basicfish
	if fsc > fish.maxcycles then
		fsc = (2*fish.maxcycles) - fish.state
		fsh = fish.revfish
	end

	for i=1,fsc do t = t .. " " end
	t = t .. awful.util.escape(fsh)
	for i=fsc,fish.maxcycles do t = t .. " " end

    fish.state = fish.state % (fish.maxcycles * 2) + 1
	fish.fg:set_text(awful.util.unescape(t))
end
fish.update()

mytimer = timer({ timeout = (1/3.0) })
mytimer:connect_signal("timeout", fish.update)
mytimer:start()

