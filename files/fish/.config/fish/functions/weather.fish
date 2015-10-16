function weather -d 'Get the weather for a zip code'
	curl -s "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=$argv" | perl -ne '/<title>([^<]+)/&&printf "\x1B[0;34m%s\x1B[0m: ",$1;/<fcttext>([^<]+)/&&print $1,"\n"';
end
