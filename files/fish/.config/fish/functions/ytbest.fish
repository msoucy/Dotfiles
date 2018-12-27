# Defined in - @ line 0
function ytbest --description 'alias ytbest=youtube-dl -f bestvideo+bestaudio'
	youtube-dl -f bestvideo+bestaudio $argv;
end
