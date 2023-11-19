upScale = 1 / 0.7;
clownOff = {};
randStatics = false;
function onCreate()
	luaDebugMode = true;
	
	initLuaShader('CTF2 Bloom');
	
	local hellclownScaleX = 0.772 * upScale * 1.2;
	local hellclownScaleY = 0.775 * upScale * 1.2;
	
	clownOff = subScrollPos(0.8);
	
	makeAnimatedLuaSprite('hellclown', 'nevada/hellclown/hellclown', (634 * upScale) + clownOff[1], (304 * upScale) + clownOff[2]);
	addAnimationByPrefix('hellclown', 'idle', 'HellClownIdle', 19);
	scaleObject('hellclown', hellclownScaleX, hellclownScaleY);
	local clownCen = getObjCen('hellclown');
	addOffset('hellclown', 'idle', clownCen[1] + (math.floor(378 * 1.2) * upScale), clownCen[2] + (math.floor(606 * 1.2) * upScale));
	setObjFrameRate('hellclown', 'idle', 19.2);
	playAnim('hellclown', 'idle', true);
	setScrollFactor('hellclown', 0.8, 0.8);
	setObjectOrder('hellclown', getObjectOrder('ground'));
	setObjAlpha('hellclown', 0.00001);
	setSpriteShader('hellclown', 'CTF2 Bloom');
	setShaderFloat('hellclown', 'radius', 5);
	setShaderFloat('hellclown', 'exponent', 2);
	setShaderFloat('hellclown', 'coeff', 0); -- 1.5
	
	local hellHandScale = 0.77217741 * upScale * 1.2;
	for i = 1, 2 do
		local t = 'hellclownHand' .. i;
		makeAnimatedLuaSprite(t, 'nevada/hellclown/hellclownHand', (634 * upScale) + (-400 * (i == 2 and -1 or 1) * upScale), (384 * upScale));
		addAnimationByPrefix(t, 'idle', 'HellClownHandsIdle', 19, true);
		scaleObject(t, hellHandScale, hellHandScale);
		if i == 2 then setProperty(t .. '.flipX', true); end
		local handCen = getObjCen(t);
		local offXHand = (i == 2 and handCen[1] + (math.floor(304 * 1.2) * upScale) or handCen[1] + (math.floor(224 * 1.2) * upScale));
		addOffset(t, 'idle', offXHand, handCen[2] + (((math.floor(28 * 1.2) * 0.77217741) + math.floor(203 * 1.2)) * upScale)); -- 224
		playAnim(t, 'idle', true);
		setObjectOrder(t, getObjectOrder('hellclown') + 1);
		setObjAlpha(t, 0.00001);
		setSpriteShader(t, 'CTF2 Bloom');
		setShaderFloat(t, 'radius', 5);
		setShaderFloat(t, 'exponent', 2);
		setShaderFloat(t, 'coeff', 0);
	end
	
	makeLuaSprite('clownMover', nil, 634 * upScale, 2000 * upScale);
	makeLuaSprite('hitMovement');
	
	precacheSound('hellclownarrives');
	
	runTimer('hellclownStatics', 0.25 / playbackRate, 0);
end

leftHandFrame = 5;
rightHandFrame = 0;
fading = false;
clownActive = false;
fadePercent = 0;
redFadeAmount = 0;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if not inGameOver then
		leftHandFrame = (leftHandFrame + (e / 0.06)) % 14;
		rightHandFrame = (rightHandFrame + (e / 0.06)) % 14;
		
		if fading then
			redFadeAmount = redFadeAmount + (e / 0.03);
			
			if redFadeAmount > 138 then 
				redFadeAmount = 138;
				fading = false;
			end
			
			while #redFadeTriggers > 0 and redFadeTriggers[1].triggerAt <= redFadeAmount do
				redFadeTriggers[1].onTrigger();
				table.remove(redFadeTriggers, 1);
			end
			
			fadePercent = (redFadeAmount + 2) / 140;
			updateFade(fadePercent);
		end
		
		if clownActive then
			local clownPos = getObjPos('clownMover');
			local hitOffset = getObjPos('hitMovement');
			
			setObjPos('hellclown', (clownPos[1] + clownOff[1]) + (hitOffset[2] * upScale), (clownPos[2] + clownOff[2]) + (hitOffset[1] * upScale));
			
			setObjPos('hellclownHand1', clownPos[1] - (400 * upScale) + ((hitOffset[1] / 4) * upScale), clownPos[2] + (80 * upScale) + ((hitOffset[2] / 4) * upScale));
			setObjPos('hellclownHand2', clownPos[1] + (400 * upScale) + ((hitOffset[1] / 4) * upScale), clownPos[2] + (80 * upScale) + ((hitOffset[2] / 4) * upScale));
			
			setCurFrame('hellclownHand1', leftHandFrame);
			setCurFrame('hellclownHand2', rightHandFrame);
		end
	end
end

redFadeTriggers = {
	{
		triggerAt = 60,
		onTrigger = function() -- screams, statics trigger
			setProperty('hellclownAppeared', true);
			randStatics = true;
			
			doSound('hellclownarrives');
		end
	},
	{
		triggerAt = 80,
		onTrigger = function() -- pan camera to hellclown
			triggerEvent('Camera To Hellclown', '', '');
		end
	},
}

function shootTheClown()
	cancelTween('hitMovementEase');
	local hitMovementMult = getRandomInt(-100, 100, '0') / 100;
	setObjPos('hitMovement', hitMovementMult * 30, 29);
	startTween('hitMovementEase', 'hitMovement', {x = 0, y = 0}, 0.15 / playbackRate, {ease = 'quadOut'});
	
	setShaderFloat('hellclown', 'coeff', 1.5);
	setShaderFloat('hellclownHand1', 'coeff', 1.2);
	setShaderFloat('hellclownHand2', 'coeff', 1.2);
	
	runTimer('hitCooldownHellclown', 0.18 / playbackRate);
end

function goodNoteHit(i, d, n)
	if noteTypeHit[n] then noteTypeHit[n](); end
end

noteTypeHit = {
	['Bullet Note'] = function()
		if clownActive then
			shootTheClown();
		end
	end
}

function noteMiss(i, d, n)
	if noteTypeMiss[n] then noteTypeMiss[n](); end 
end

noteTypeMiss = {
	['Bullet Note'] = function()
		if clownActive then
			shootTheClown();
		end
	end
}

otherTimers = {}; -- using this code that Cherif gave me a while back
function addTimer(time, onComplete)
    otherTimers[#otherTimers + 1] = onComplete or function() end;
    runTimer("TIMERHC_" .. #otherTimers, time);
end

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
	if t:find("TIMERHC_") then otherTimers[tonumber((t:gsub("TIMERHC_", "")))](); end
end

timers = {
	['hellclownStatics'] = function()
		if randStatics and getRandomInt(1, 6) == 1 then
			triggerStatic();
		end
	end,
	['hellclown'] = function()
		fading = true;
		clownActive = true;
		
		setObjAlpha('hellclown', 1);
		setObjAlpha('hellclownHand1', 1);
		setObjAlpha('hellclownHand2', 1);
		
		doTweenY('hellclownRises', 'clownMover', 304 * upScale, 4 / playbackRate, 'quadout');
	end,
	['hitCooldownHellclown'] = function()
		setShaderFloat('hellclown', 'coeff', 0);
		setShaderFloat('hellclownHand1', 'coeff', 0);
		setShaderFloat('hellclownHand2', 'coeff', 0);
	end
}

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Start Hellclown Statics'] = function()
		addTimer(2 / playbackRate, function() triggerStatic('NO', 0.54); end);
		addTimer(2.27 / playbackRate, function() triggerStatic('INVALID', 0.54); end);
		addTimer(2.75 / playbackRate, function() triggerStatic('CLOWN CANNOT DIE', 0.54); end);
		addTimer(2.89 / playbackRate, function() triggerStatic('RE-ENGAGE', 0.54); end);
		addTimer(3.08 / playbackRate, function() triggerStatic('CORRECTION', 0.75); end);
		addTimer(3.24 / playbackRate, function() triggerStatic('Reboot.useSeed(sRAND);', 0.75); end);
		runTimer('hellclown', 3.64 / playbackRate);
	end
}
