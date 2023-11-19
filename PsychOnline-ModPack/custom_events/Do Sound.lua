function onCreatePost()
	for i = 0, getProperty('eventNotes.length') - 1 do
		if getPropertyFromGroup('eventNotes', i, 'event') == 'Play Sound' then
			precacheSound(getPropertyFromGroup('eventNotes', i, 'value1'));
		end
	end
	
	runHaxeCode([[
		createCallback('setSoundPitch', function(t:String, p:Float) {
			game.modchartSounds.get(t).pitch = p;
		});
	]]);
end

function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Do Sound'] = function(v1, v2)
		doSound(v1, tonumber(v2));
	end
}

totHit = 0;
function doSound(file, volume)
    if volume == nil then volume = 1 end
	totHit = totHit + 1;
	local t = file..totHit
	playSound(file, volume, t);
	setSoundPitch(t, playbackRate);
end