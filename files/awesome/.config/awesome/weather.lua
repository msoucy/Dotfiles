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
		units = "imperial",
		zip = zip,
		data = "",
		formats = {
			-- Sunny
			["01"] = {icon="☀", fg="#fff92e"},
			-- Cloudy
			["02"] = {icon="☁", fg="#33CCFF"},
			["03"] = {icon="☁", fg="#33CCFF"},
			["04"] = {icon="☁", fg="#33CCFF"},
			-- Rain
			["09"] = {icon="☂", fg="#008080"},
			["10"] = {icon="☂", fg="#008080"},
			-- Lightning
			["11"] = {icon="☈", fg="#FCC01E"},
			-- Snow
			["13"] = {icon="❅", fg="#BBBBBB"},
			-- Mist
			["50"] = {icon="≡", fg="#BCBBA9"}
		}
	}
	for k,v in pairs(config or {}) do wid[k] = v end
	wid.fg:set_align("right")
	wid.widget:set_widget(wid.fg)

	function wid.display(data, fg)
		wid.widget:set_fg(fg)
		wid.fg:set_text(" " .. awful.util.unescape(wid.data))
	end

	function wid.update()
		local baseurl = "http://api.openweathermap.org/data/2.5/weather"
		local url = "?zip=%s&units=%s&appid=%s"
		local appid = "68cbb05e407c673c308de30908beb20f"
		local prep_url = string.format(baseurl .. url, wid.zip, wid.units, appid)
		local text = awful.util.pread(string.format("curl '%s'", prep_url)):match("(.-)%s*$")
		local jdata = json.decode(text)

		local degree = jdata["main"]["temp"]
		local iconame = string.sub(jdata["weather"][1]["icon"], 1, -2)
		local wdata = wid.formats[iconame] or {icon="?", fg="#33CCFF"}
		wid.data = degree .. "° " .. wdata.icon
		wid.desc = jdata["weather"][1]["description"]:gsub("^%l", string.upper)
		wid.display(wid.data, wdata.fg)
	end

	function wid.show(text)
		naughty.notify({ text = text, timeout = 3 })
	end

	function wid.show_desc()
		wid.show(wid.desc)
	end

	function wid.manual_update()
		wid.show("Updating weather")
		wid.update()
	end

	wid.fg:buttons(awful.util.table.join(
		awful.button({}, 1, wid.show_desc),
		awful.button({}, 3, wid.manual_update)
	))

	wid.update()
	mytimer = timer({ timeout = wid.timeout })
	mytimer:connect_signal("timeout", wid.update)
	mytimer:start()

	return wid.widget

end

return weather
