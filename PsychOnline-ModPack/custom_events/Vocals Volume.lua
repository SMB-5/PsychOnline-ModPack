function onEvent(n)
	if events[n] then
		events[n]();
	end
end

events = {
	['Vocals Volume'] = function()
		setProperty('vocals.volume', 1);
	end
}
