upScale = 1 / 0.7;
heliY = 0;
function onCreatePost()
	local heliOff = subScrollPos(0.25);
	heliY = ((70 - math.floor(192 * 0.8)) * upScale) + heliOff[2];
	makeAnimatedLuaSprite('heli', 'nevada/helicopter', ((-424 - math.floor(341 * 0.8)) * upScale) + heliOff[1], heliY);
	addAnimationByPrefix('heli', 'idle', 'Helicopter', 30, true);
	scaleObject('heli', 1.03367496 * (upScale * 0.8), 1.03367496 * (upScale * 0.8));
	playAnim('heli', 'idle', true);
	setScrollFactor('heli', 0.25, 0.25);
	setProperty('heli.color', getColorFromHex('976666'));
	setObjectOrder('heli', getObjectOrder('sky') + 1);
end

function onEvent(n)
	if events[n] then
		events[n]();
	end
end

events = {
	['Heli Fly By'] = function()
		isFlying = true;
	end
}

isFlying = false;
totEl = 0;
function onUpdatePost(e)
	e = e * playbackRate;
	if isFlying and not inGameOver then
		totEl = totEl + e;
		if totEl >= (1 / 60) then
			totEl = 0;
			shakeHeli();
		end
		setProperty('heli.velocity.x', ((4 + getRandomInt(-1, 1)) * upScale * 60));
		
		if getScreenPositionX('heli') > getScreenPositionX('sky') + getWidth('sky') then
			removeLuaSprite('heli');
			
			isFlying = false;
		end
	end
end

function shakeHeli()
	
	setProperty('heli.y', heliY + (getRandomInt(-1, 1) * upScale));
end
