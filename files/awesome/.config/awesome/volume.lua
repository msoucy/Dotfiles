local awful = require("awful")
local naughty = require("naughty")

volume_widget = awful.widget.progressbar({ width = 16 })
volume_widget:set_vertical(true)
volume_widget:set_ticks(true)
volume_widget:set_max_value(100)

local normcolor = function(v, end_color, start_color)
	return math.floor(v * (end_color - start_color) + start_color)
end

volume_widget.update = function()
   local status = awful.util.pread("amixer sget Master")

   local volume = math.min(tonumber(string.match(status, "(%d?%d?%d)%%")), 100)

   status = string.match(status, "%[(o[^%]]*)%]")

   local ir = normcolor(volume/100, 0xDC, 0x3F)
   local ig = normcolor(volume/100, 0xDC, 0x3F)
   local ib = normcolor(volume/100, 0xCC, 0x3F)
   local interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, ib)
   local couldfind = string.find(status, "on", 1, true)
   volume_widget:set_color(couldfind and interpol_colour or "FF0000")
   volume_widget:set_value(volume)
   volume_widget.volume = volume
end

local volcommand = function(cmd)
	return function()
		awful.util.pread(cmd)
		volume_widget.update()
	end
end

volume_widget.up = volcommand("amixer set Master 5%+")
volume_widget.down = volcommand("amixer set Master 5%-")
volume_widget.toggle = volcommand("amixer set Master toggle")
volume_widget.read_raw = function() awful.util.pread("amixer sget Master") end

volume_widget.update()

mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", volume_widget.update)
mytimer:start()

volume_widget:buttons(awful.util.table.join(
	awful.button({}, 1, function()
		naughty.notify({text = "Volume: " .. volume_widget.volume .. "%"})
	end),
	awful.button({}, 3, volume_widget.toggle),
	awful.button({}, 4, volume_widget.up),
	awful.button({}, 5, volume_widget.down)
))

return volume_widget
