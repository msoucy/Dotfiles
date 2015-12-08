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
		icons = {
			["01"] = "☀",
			["02"] = "☁",
			["03"] = "☁",
			["04"] = "☁",
			["09"] = "☂",
			["10"] = "☂",
			["11"] = "☈",
			["13"] = "❅",
			["50"] = "≡"
		}
	}
	for k,v in pairs(config or {}) do wid[k] = v end
	wid.fg:set_align("right")
	wid.widget:set_widget(wid.fg)
	wid.widget:set_fg("#33CCFF")
	wid.widget:set_bg("#404040")

	function wid.display(data)
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
		local icon = wid.icons[string.sub(jdata["weather"][1]["icon"],1,-2)] or "?"
		wid.data = degree .. "° " .. icon
		wid.desc = jdata["weather"][1]["description"]:gsub("^%l", string.upper)
		wid.display(wid.data)
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
