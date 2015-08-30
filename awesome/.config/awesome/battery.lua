local awful = require("awful")
local naughty = require("naughty")

battery_widget = awful.widget.progressbar({ width = 8 })
battery_widget:set_vertical(true)
battery_widget:set_ticks(true)
battery_widget:set_max_value(100)

local wraparound = 0

local catfile = function(name, fmt)
	local fh = io.open(name)
	return fh:read(fmt or "*n")
end

local alert = function(battery)
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Battery critical!",
		text = string.format("Save your work now, battery at %d%%",
							 math.floor(battery*100))
	})
end

-- Create a battery monitor widget
battery_widget.update = function()
	local widget = battery_widget
	-- Get all battery "directories"
	local batteries = awful.util.pread("find /sys/class/power_supply -maxdepth 1 -name 'BAT*'")
	-- Running totals
	local energy_now = 0
	local energy_full = 0

	-- Add each battery's values to the running total
	for battery in batteries:gmatch("[^\r\n]+") do
		energy_now = energy_now + catfile(battery.."/energy_now")
		energy_full = energy_full + catfile(battery.."/energy_full")
	end

	-- Check for plugged-in status
	widget.charging = catfile("/sys/class/power_supply/AC/online") ~= 0

	-- Get the new colors and positions
	local battery = energy_now / energy_full
	local fg_color = "FF0000"
	if widget.charging then
		fg_color = "00FF00"
	else
		-- Show an alert when low every 30s
		if battery <= .05 then
			if wraparound == 0 then
				alert(battery)
			end
			wraparound = (wraparound + 1) % 3
		end
	end
	widget.level = battery * 100
	widget:set_value(battery_widget.level)
	widget:set_color(fg_color)
end

battery_widget.update()

mytimer = timer({ timeout = 10 })
mytimer:connect_signal("timeout", battery_widget.update)
mytimer:start()

battery_widget:buttons(awful.util.table.join(
	awful.button({}, 1, function()
		local text = "Charging"
		if not battery_widget.charging then text = "Discharging" end
		naughty.notify({
		text = string.format("Battery level: %d%% (%s)",
		                     math.floor(battery_widget.level), text)
	}) end)
))

