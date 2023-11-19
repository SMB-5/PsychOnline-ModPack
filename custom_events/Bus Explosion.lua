local upScale = 1 / 0.7;
function onCreatePost()
	luaDebugMode = true;
	local exploSub = subScrollPos(0);
	makeAnimatedLuaSprite('explosionBus', 'street/bus/explosion', (1347 * upScale) + exploSub[1], (324 * upScale) + exploSub[2]);
	addAnimationByPrefix('explosionBus', 'explosion', 'Explosion', 19, false);
	scaleObject('explosionBus', upScale, upScale);
	local exploCen = getObjCen('explosionBus');
	addOffset('explosionBus', 'explosion', exploCen[1] + (620 * upScale), exploCen[2] + (520 * upScale));
	setObjFrameRate('explosionBus', 'explosion', 19.2);
	playAnim('explosionBus', 'explosion', true);
	setScrollFactor('explosionBus', 0, 0);
	addLuaSprite('explosionBus', true);
	setObjAlpha('explosionBus', 0.00001);
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Bus Explosion'] = function()
		cameraShake('game', 0.01, 0.15 / playbackRate);
		
		setObjAlpha('explosionBus', 1);
		playAnim('explosionBus', 'explosion', true);
		setProperty('explosionBus.velocity.x', (-5 / 0.05) * upScale);
		removeObjOnFinishAnim('explosionBus');
	end
}

function math.lerp(a, b, ratio) return a + ratio * (b - a); end