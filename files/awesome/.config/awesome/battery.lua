local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")

battery_widget = wibox.widget {
	{
		max_value = 1,
		ticks = true,
		shape = gears.shape.rounded_bar,
		widget = wibox.widget.progressbar,
	},
	forced_width = 8,
	direction = "east",
	layout = wibox.container.rotate,
	level=0,
}

local catfile = function(name, fmt)
	local fh = io.open(name)
	return fh:read(fmt or "*n")
end

battery_widget.alerttimer = timer {
	timeout = 30,
	callback = function()
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Battery critical!",
			text = string.format("Save your work now, battery at %d%%",
								 math.floor(battery_widget.level))
		})
	end
}

-- Create a battery monitor widget
battery_widget.update = function()
	local widget = battery_widget
	local battery_cmd = "find /sys/class/power_supply -maxdepth 1 -name 'BAT*'"
	-- Get all battery "directories"
	awful.spawn.easy_async(battery_cmd, function(stdout)
		-- Running totals
		local energy_now = 0
		local energy_full = 0

		-- Add each battery's values to the running total
		for battery in stdout:gmatch("[^\r\n]+") do
			energy_now = energy_now + catfile(battery.."/energy_now")
			energy_full = energy_full + catfile(battery.."/energy_full")
		end

		-- Get the battery percentage
		local battery = energy_now / energy_full

		-- Check for plugged-in status
		widget.charging = catfile("/sys/class/power_supply/AC/online") ~= 0

		-- Show an alert when low every 30s
		if (not widget.charging) and (battery <= .05) then
			battery_widget.alerttimer:start()
		else
			battery_widget.alerttimer:stop()
		end

		-- Store widget values
		widget.level = battery * 100
		widget.widget:set_value(battery)
		widget.widget.color = widget.charging and "#00FF00" or "#FF0000"
	end)
end

battery_widget.update()

battery_widget.updatetimer = timer {
	timeout = 10,
	callback = battery_widget.update
}
battery_widget.updatetimer:start()

battery_widget:buttons(gears.table.join(
	awful.button({}, 1, function()
		local text = battery_widget.charging and "Charging" or "Discharging"
		naughty.notify({
		text = string.format("Battery level: %d%% (%s)",
		                     math.floor(battery_widget.level), text)
		})
	end)
))

return battery_widget
