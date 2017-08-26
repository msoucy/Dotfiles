local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local colors = require("colorgradient")

local base_widget = wibox.widget {
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

local volume_update = function(widget, stdout)
	local volume = math.min(tonumber(string.match(stdout, "(%d?%d?%d)%%")), 100)

	local status = string.match(stdout, "%[(o[^%]]*)%]")

	local interpol_color = colors.colorFrom(
		volume,
		0x3F, 0x3F, 0x3F,
		0xDC, 0xDC, 0xCC)
	local couldfind = string.find(status, "on", 1, true)

	widget.widget.color = couldfind and interpol_color or "#FF0000"
	widget.widget:set_value(volume)
	widget.volume = volume
end

local volume_widget = awful.widget.watch (
	"amixer sget Master", 1, volume_update, base_widget
)

local volcommand = function(cmd)
	return function()
		awful.spawn.easy_async(cmd, function(stdout)
			volume_update(volume_widget, stdout)
		end)
	end
end

volume_widget.up = volcommand("amixer set Master 5%+")
volume_widget.down = volcommand("amixer set Master 5%-")
volume_widget.toggle = volcommand("amixer set Master toggle")

volume_widget:buttons(gears.table.join(
	awful.button({}, 1, function()
		naughty.notify({text = "Volume: " .. volume_widget.volume .. "%"})
	end),
	awful.button({}, 3, volume_widget.toggle),
	awful.button({}, 4, volume_widget.up),
	awful.button({}, 5, volume_widget.down)
))

return volume_widget
