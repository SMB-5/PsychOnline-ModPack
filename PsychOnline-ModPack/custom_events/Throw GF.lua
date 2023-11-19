upScale = 1 / 0.7 ;
function onCreate()
	makeLuaSprite('gfThrow', 'nevada/gfFlyAway', 372 * upScale, 52 * upScale);
	scaleObject('gfThrow', upScale, upScale);
	setObjectOrder('gfThrow', getObjectOrder('gfGroup') + 1);
	setObjAlpha('gfThrow', 0.00001);
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Throw GF'] = function()
		setObjAlpha('gfThrow', 1);
		
		doTweenX('gfThrown', 'gfThrow', ((640 / 0.7) - 640) + (2000 * upScale), 0.2);
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['gfThrown'] = function()
		removeLuaSprite('gfThrow');
	end
}