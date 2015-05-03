local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

volume_widget = awful.widget.progressbar({ width = 8 })
volume_widget:set_vertical(true)
volume_widget:set_ticks(true)
volume_widget:set_max_value(1.0)

function update_volume(widget)
   local status = awful.util.pread("amixer sget Master")

   local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) / 100
   if volume > 1.0 then
      volume = 1.0
   end

   status = string.match(status, "%[(o[^%]]*)%]")

   -- starting colour
   local sr, sg, sb = 0x3F, 0x3F, 0x3F
   -- ending colour
   local er, eg, eb = 0xDC, 0xDC, 0xCC

   local ir = volume * (er - sr) + sr
   local ig = volume * (eg - sg) + sg
   local ib = volume * (eb - sb) + sb
   local interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, ib)
   local couldfind = string.find(status, "on", 1, true)
   widget:set_color(couldfind and interpol_colour or "FF0000")
   widget:set_value(volume)
   widget.volume = volume
end

update_volume(volume_widget)

mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()

volume_widget:buttons(awful.util.table.join(
	awful.button({}, 1, function()
		naughty.notify({text = "Volume: " .. volume_widget.volume * 100 .. "%"})
	end)
))

