upScale = 1 / 0.7;
tordOffset = {};
torX = 0;
function onCreate()
	luaDebugMode = true;
	
	tordOffset = subScrollPos(0.9);
	torX = tordOffset[1] + (660 * upScale);
	makeAnimatedLuaSprite('tordBot', 'eddsworld/end mix/tord/tordBot', torX, tordOffset[2] + (362 * upScale));
	addAnimationByPrefix('tordBot', 'idle', 'TordBotIdle', 21);
	addAnimationByPrefix('tordBot', 'idle-alt', 'TordBotHarpoonIdle', 21);
	addAnimationByPrefix('tordBot', 'explode', 'TordBotBlowingUp', 10, false);
	scaleObject('tordBot', upScale, upScale);
	local tordCen = getObjCen('tordBot');
	addOffset('tordBot', 'idle', tordCen[1] + (382 * upScale), tordCen[2] + (332 * upScale));
	addOffset('tordBot', 'idle-alt', tordCen[1] + (837 * upScale), tordCen[2] + (509.5 * upScale));
	addOffset('tordBot', 'explode', tordCen[1] + (837 * upScale), tordCen[2] + (509.5 * upScale));
	setObjFrameRate('tordBot', 'explode', 9.6);
	playAnim('tordBot', 'idle', true);
	setScrollFactor('tordBot', 0.9, 0.9);
	setObjectOrder('tordBot', getObjectOrder('houses'));
	
	if not lowQuality then
		local fScale = 0.8075 * upScale;
		makeAnimatedLuaSprite('tordFlails', 'eddsworld/end mix/tord/tordFlails', 200, 200);
		addAnimationByPrefix('tordFlails', 'flail', 'TordFlailing', 19);
		setScrollFactor('tordFlails', 0.95, 0.95);
		scaleObject('tordFlails', fScale, fScale);
		local flailCen = getObjCen('tordFlails');
		addOffset('tordFlails', 'flail', flailCen[1] + (86 * upScale), flailCen[2] + (67 * upScale));
		playAnim('tordFlails', 'flail', true);
		setObjFrameRate('tordFlails', 'flail', 19.2);
		setObjectOrder('tordFlails', getObjectOrder('tordBot'));
		setObjAlpha('tordFlails', 0.00001); 
	end
end

function onSongStart()
	if not lowQuality then setObjAlpha('tordFlails', 0); end
end

function onCreatePost()
	addLuaScript('scriptChars/tord');
	addLuaScript('scriptChars/bfTord');
	callOnLuas('loadMix', {});
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['TordBot Rise'] = function()
		doTweenY('tordRiseY', 'tordBot', (-159 * upScale) + tordOffset[2], 4.772 / playbackRate);
		cameraShake('game', 4 / 640, 4.772 / playbackRate);
		doShake = true;
	end,
	['TordBot Snap Pos'] = function()
		cancelTween('tordRiseY');
		
		setObjPos('tordBot', (660 * upScale) + tordOffset[1], (-159 * upScale) + tordOffset[2]);
		cameraShake('game', 0, 0.00001);
		doShake = false;
	end,
	['TordBot End Shake'] = function()
		setProperty('tordBot.velocity.y', (upScale / 0.08) * playbackRate);
		playAnim('tordBot', 'idle-alt', true);
		doShake = true;
		shakeNum = 7;
	end,
	['TordBot Explode'] = function()
		endShake = true;
		doShake = false;
		playAnim('tordBot', 'explode', true);
		removeObjOnFinishAnim('tordBot');
		
		if not lowQuality then
			local tordFlailOff = subScrollPos(0.95);
			setObjPos('tordFlails', tordFlailOff[1] + (620 * upScale), tordFlailOff[2] + (-448 * upScale));
			setObjAlpha('tordFlails', 1);
			playAnim('tordFlails', 'flail', true);
			
			
			setProperty('tordFlails.velocity.y', (-30 * 20 * upScale) * playbackRate); -- this is the closest ill get to getting this accurate since it uses some other math im too lazy to figure out
			setProperty('tordFlails.acceleration.y', (610 * upScale) * playbackRate); -- it doesnt work well with other playbackrates but i do not want to fix that
			setProperty('tordFlails.maxVelocity.y', (30 * 20 * upScale));
		end
	end
}

doShake = false;
shakeNum = 2;
function onUpdatePost(e)
	e = e * playbackRate;
	if doShake and not inGameOver then
		setObjX('tordBot', torX + (getRandomInt(-shakeNum, shakeNum) * upScale));
	end
end
