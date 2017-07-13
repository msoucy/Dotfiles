local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")

volume_widget = wibox.widget {
	{
		max_value = 100,
		ticks = true,
		widget = wibox.widget.progressbar,
		border_width = 5,
		margins = {
			top = 6,
			bottom = 6,
		},
		clip = false,
		shape = gears.shape.rounded_bar,
	},
	forced_width = 16,
	direction = "east",
	layout = wibox.container.rotate,
}

local normcolor = function(v, end_color, start_color)
	return math.floor(v * (end_color - start_color) + start_color)
end

volume_widget.update = function()
	awful.spawn.easy_async("amixer sget Master", function(stdout)
		local volume = math.min(tonumber(string.match(stdout, "(%d?%d?%d)%%")), 100)

		local status = string.match(stdout, "%[(o[^%]]*)%]")

		local ir = normcolor(volume/100, 0xDC, 0x3F)
		local ig = normcolor(volume/100, 0xDC, 0x3F)
		local ib = normcolor(volume/100, 0xCC, 0x3F)
		local interpol_colour = string.format("#%.2X%.2X%.2X", ir, ig, ib)
		local couldfind = string.find(status, "on", 1, true)

		volume_widget.widget.color = couldfind and interpol_colour or "#FF0000"
		volume_widget.widget:set_value(volume)
		volume_widget.volume = volume
	end)
end

local volcommand = function(cmd)
	return function()
		awful.spawn.easy_async(cmd, function(stdout)
			volume_widget.update()
		end)
	end
end

volume_widget.up = volcommand("amixer set Master 5%+")
volume_widget.down = volcommand("amixer set Master 5%-")
volume_widget.toggle = volcommand("amixer set Master toggle")

volume_widget.update()

mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", volume_widget.update)
mytimer:start()

volume_widget:buttons(gears.table.join(
	awful.button({}, 1, function()
		naughty.notify({text = "Volume: " .. volume_widget.volume .. "%"})
	end),
	awful.button({}, 3, volume_widget.toggle),
	awful.button({}, 4, volume_widget.up),
	awful.button({}, 5, volume_widget.down)
))

return volume_widget
