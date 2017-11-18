local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local json = require("json")
local gears = require("gears")

-- Port of basic logic from:
-- github.com:Wildog/airline-weather.vim/autoload/weather.vim

function weather(zip, config)
	wid = {
		timeout = 600,
		widget = wibox.widget.textbox(),
		units = "imperial", -- Yes, I'm a terrible person
		formats = {
			-- Sunny
			["01"] = {icon="&#x2600;", fg="#FFF92E"},
			-- Cloudy
			["02"] = {icon="&#x26c5;", fg="#F3F2E7"}, -- Partly Cloudy
			["03"] = {icon="&#x2601;", fg="#F3F2E7"}, -- Cloudy
			["04"] = {icon="&#x2601;", fg="#F3F2E7"},
			-- Rain
			["09"] = {icon="&#9730;", fg="#008080"}, -- Rain
			["10"] = {icon="&#9748;", fg="#008080"}, -- Shower Rain
			-- Lightning
			["11"] = {icon="&#x26a1;", fg="#FCC01E"},
			-- Snow
			["13"] = {icon="&#x2744;", fg="Snow"},
			-- Mist
			["50"] = {icon="&#x1f32b;", fg="#BCBBA9"}
		},
		align = "right",
	}
	gears.table.crush(wid, config or {})

	function mkspan(text, attrs)
		local ret = ""
		for k,v in pairs(attrs or {}) do
			ret = ret .. " " .. k .. "='" .. v .. "'"
		end
		return "<span" .. ret .. ">" .. text .. "</span>"
	end

	function wid.update()
		local baseurl = "http://api.openweathermap.org/data/2.5/weather"
		local url = "?zip=%s&units=%s&appid=%s"
		local appid = "68cbb05e407c673c308de30908beb20f"
		local prep_url = string.format(baseurl .. url, zip, wid.units, appid)
		awful.spawn.easy_async(string.format("curl '%s'", prep_url), function(text)

			-- Sometimes we don't have network, so set default values
			wid.desc = "Could not get weather - make sure internet connection is enabled and right-click applet"
			wid.data = "???°"
			local jdata = json.decode(text)
			if jdata and jdata.main then
				wid.data = mkspan(jdata.main.temp .. "°", {size="large"})
				wid.desc = ""
				for _, wtab in pairs(jdata.weather) do
					local iconame = string.sub(wtab.icon, 1, -2)
					local wdata = wid.formats[iconame] or {icon="?", fg="#33CCFF"}
					wid.data = wid.data .. " " .. mkspan(wdata.icon, {color=wdata.fg, size="x-large"})
					wid.desc = wid.desc .. wtab.description:gsub("^%l", string.upper) .. "\n"
				end
			end
			wid.desc = wid.desc:gsub("^%s*(.-)%s*$", "%1")

			wid.widget:set_markup(" " .. gears.string.xml_unescape(wid.data) .. " ")
		end)
	end

	function alert(text)
		naughty.notify({ text = text, timeout = 3 })
	end


	wid.widget:buttons(gears.table.join(
		awful.button({}, 1, function()
			alert(wid.desc)
		end),
		awful.button({}, 3, function()
			alert("Updating weather")
			wid.update()
		end)
	))

	wid.update()
	mytimer = timer {
		timeout = wid.timeout,
		callback = wid.update,
	}
	mytimer:start()

	return wid.widget

end

return weather
