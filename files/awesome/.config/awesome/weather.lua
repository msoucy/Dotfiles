local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local json = require("json")

-- Port of basic logic from:
-- github.com:Wildog/airline-weather.vim/autoload/weather.vim

function weather(zip, config)
	wid = {
		timeout = 600,
		fg = wibox.widget.textbox(),
		widget = wibox.widget.background(),
		units = "imperial", -- Yes, I'm a terrible person
		formats = {
			-- Sunny
			["01"] = {icon="☀", fg="#FFF92E"},
			-- Cloudy
			["02"] = {icon="☁", fg="#F3F2E7"},
			["03"] = {icon="☁", fg="#F3F2E7"},
			["04"] = {icon="☁", fg="#F3F2E7"},
			-- Rain
			["09"] = {icon="☂", fg="#008080"},
			["10"] = {icon="☂", fg="#008080"},
			-- Lightning
			["11"] = {icon="☈", fg="#FCC01E"},
			-- Snow
			["13"] = {icon="❅", fg="Snow"},
			-- Mist
			["50"] = {icon="≡", fg="#BCBBA9"}
		}
	}
	for k,v in pairs(config or {}) do wid[k] = v end
	wid.fg:set_align("right")
	wid.widget:set_widget(wid.fg)

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
		local text = awful.util.pread(string.format("curl '%s'", prep_url)):match("(.-)%s*$")

		-- Sometimes we don't have network, so set default values
		wid.desc = "Could not get weather - make sure internet connection is enabled and right-click applet"
		wid.data = "???°"
		local jdata = json.decode(text)
		if jdata then
			wid.data = jdata.main.temp .. "°"
			wid.desc = ""
			for _, wtab in pairs(jdata.weather) do
				local iconame = string.sub(wtab.icon, 1, -2)
				local wdata = wid.formats[iconame] or {icon="?", fg="#33CCFF"}
				wid.data = wid.data .. " " .. mkspan(wdata.icon, {color=wdata.fg})
				wid.desc = wid.desc .. wtab.description:gsub("^%l", string.upper) .. "\n"
			end
		end
		wid.desc = wid.desc:gsub("^%s*(.-)%s*$", "%1")

		wid.fg:set_markup(" " .. awful.util.unescape(wid.data) .. " ")
	end

	function alert(text)
		naughty.notify({ text = text, timeout = 3 })
	end


	wid.fg:buttons(awful.util.table.join(
		awful.button({}, 1, function()
			alert(wid.desc)
		end),
		awful.button({}, 3, function()
			alert("Updating weather")
			wid.update()
		end)
	))

	wid.update()
	mytimer = timer({ timeout = wid.timeout })
	mytimer:connect_signal("timeout", wid.update)
	mytimer:start()

	return wid.widget

end

return weather
