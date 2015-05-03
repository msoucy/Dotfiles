local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

battery_widget = awful.widget.progressbar({ width = 8 })
battery_widget:set_vertical(true)
battery_widget:set_ticks(true)

local wraparound = 0

-- Create a battery monitor widget
battery_widget.update = function()
	local widget = battery_widget
    local status = awful.util.pread("acpi -b")

	widget:set_color('FF0000')
	widget:set_value(0)
	if status:len() ~= 0 then
		local battery = tonumber(string.match(status, "(%d?%d?%d)%%")) / 100


		status = string.match(status, ": (%w+)")

		-- starting colour
		local sr, sg, sb = 0x3F, 0x3F, 0x3F
		-- ending colour
		local er, eg, eb = 0xDC, 0xDC, 0xCC

		local ir = battery * (er - sr) + sr
		local ig = battery * (eg - sg) + sg
		local ib = battery * (eb - sb) + sb
		local interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, ib)
		local fg_color = "green"
		if string.find(status, "Discharging", 1, true) then
			fg_color = "FF0000"
			if battery <= .05 then
				if wraparound == 0 then
					naughty.notify({ preset = naughty.config.presets.critical,
									 title = "Battery critical!",
									 text = string.format("Save your work now, battery at %d%%", battery*100) })
				end
				wraparound = (wraparound + 1) % 3
			end
		else
			fg_color = "00FF00"
		end
		battery_widget.level = battery * 100
		battery_widget:set_value(battery_widget.level)
		battery_widget:set_color(fg_color)
	end
end

battery_widget.update()

mytimer = timer({ timeout = 10 })
mytimer:connect_signal("timeout", battery_widget.update)
mytimer:start()

battery_widget:buttons(awful.util.table.join(
	awful.button({}, 1, function() naughty.notify({
		text = "Battery level: " .. battery_widget.level .. "%"
	}) end)
))

