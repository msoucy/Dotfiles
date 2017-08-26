local naughty = require("naughty")

local colors = {}

colors.normColor = function(v, end_color, start_color)
	return math.floor(v * (end_color - start_color) + start_color)
end

colors.colorFrom = function(value, lR, lG, lB, hR, hG, hB)
	local ir = colors.normColor(value/100, hR, lR)
	local ig = colors.normColor(value/100, hG, lG)
	local ib = colors.normColor(value/100, hB, lB)
	return string.format("#%.2X%.2X%.2X", ir, ig, ib)
end

return colors
