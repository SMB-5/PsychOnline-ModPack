function onCreate()
	makeAnimatedLuaSprite('halloweenBG', 'halloweenAttic/halloween_bg', -200, -100);
		addAnimationByPrefix('halloweenBG', 'halloweem bg', 'halloweem bg', 0, false);

	addLuaSprite('halloweenBG', false);

	objectPlayAnimation('halloweenBG', 'halloweem bg', true);
end

local lightningStrikeBeat = 0
local lightningOffset = 8
function lightningStrikeShit()
	playSound('thunder_' ..  math.random(1,2), 0.5);

	lightningStrikeBeat = curBeat;
	lightningOffset = math.random(8,24);
end

function onBeatHit()
	checkValue = math.random(0,10);
	if checkValue == 10 and curBeat > lightningStrikeBeat + lightningOffset then
		lightningStrikeShit();
	end
end