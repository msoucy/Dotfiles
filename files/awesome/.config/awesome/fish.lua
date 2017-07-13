local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

fish = { state = 1, basicfish = ">})°>", revfish = "<°({<" , maxcycles = 8}
fish.widget = wibox.widget {
	{
		widget = wibox.widget.textbox,
		align = "right",
	},
	fg = "#DD4400",
	bg = "#33CCFF",
	widget = wibox.widget.background,
}

function fish.fortune()
	awful.spawn.easy_async("fortune -s", function(msg)
		naughty.notify({
			text = msg:match("(.-)%s*$"),
			timeout = 7
		})
	end)
end

fish.widget:buttons(gears.table.join(
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
	t = t .. gears.string.xml_escape(fsh)
	for i=fsc,fish.maxcycles do t = t .. " " end

    fish.state = fish.state % (fish.maxcycles * 2) + 1
	fish.widget.widget.text = gears.string.xml_unescape(t)
end
fish.update()

fish.mytimer = timer {
	timeout = 0.3,
	callback = fish.update,
}
fish.mytimer:start()

return fish.widget
