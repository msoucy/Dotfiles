local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

volume_widget = awful.widget.progressbar({ width = 16 })
volume_widget:set_vertical(true)
volume_widget:set_ticks(true)
volume_widget:set_max_value(1.0)

volume_widget.update = function()
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

   local ir = math.floor(volume * (er - sr) + sr)
   local ig = math.floor(volume * (eg - sg) + sg)
   local ib = math.floor(volume * (eb - sb) + sb)
   local interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, ib)
   local couldfind = string.find(status, "on", 1, true)
   volume_widget:set_color(couldfind and interpol_colour or "FF0000")
   volume_widget:set_value(volume)
   volume_widget.volume = volume
end

volume_widget.up = function()
	awful.util.pread("amixer set Master 5%+")
end

volume_widget.down = function()
	awful.util.pread("amixer set Master 5%-")
end

volume_widget.toggle = function()
	awful.util.pread("amixer set Master toggle")
end

volume_widget.update()

mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", volume_widget.update)
mytimer:start()

volume_widget:buttons(awful.util.table.join(
	awful.button({}, 1, function()
		naughty.notify({text = "Volume: " .. volume_widget.volume*100 .. "%"})
	end),
	awful.button({}, 3, volume_widget.toggle),
	awful.button({}, 4, volume_widget.up),
	awful.button({}, 5, volume_widget.down)
))

