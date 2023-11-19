upScale = 1 / 0.7;
kidScale = 0.93265993 * upScale * 1.12;
dadPos = {};
uberDead = false;
canRespawn = true;
beingPulled = false;
bringBackMic = true;
uberPullAmount = 0;
function onCreate()
	luaDebugMode = true;
	
	scaleObject('dad', kidScale, kidScale);
	resizeOffsets('dad', kidScale);
	
	local singAnims = getProperty('singAnimations');
	for i = 1, 4 do
		setObjFrameRate('dad', singAnims[i], 19.2);
	end
	setObjFrameRate('dad', 'idle-alt', 19.2);
	setObjFrameRate('dad', 'react', 14.4);
	
	runHaxeCode([[
		createCallback('uberKidFinAnim', function(o) {
			var obj = game.modchartSprites.get(o);
			obj.animation.finishCallback = function(n) {
				parentLua.call('uberkidFinishAnim', [o, n]);
			}
		});
		
		createGlobalCallback('runOverUber', function() {
			parentLua.call('busUberkid', []);
		});
	]]);
	
	dadPos = getObjPos('dad');
	
	precacheSound('uberHit');
end

function onUpdatePost(e)
	e = e * playbackRate;
	
	if not inGameOver then
		if uberPullAmount > 0 then
			uberPullAmount = uberPullAmount - (e / 0.08);
		end
		
		if beingPulled then
			addToX('uberkidDies', -uberPullAmount * (e * 60) * upScale);
		end
		
		if ontoBus then
			setObjX('runOverUber', getObjX('bus') + ((1180 + 1064) * upScale));
		end
	end
end

function killKid(m) -- kills the uberkid if he isnt dead already
	if not uberDead then
		m = m or false; -- make mic go weeeeeee
		uberDead = true;
		beingPulled = false;
		
		setObjAlpha('dadGroup', 0.00001);
		setObjAlpha('uberkidDies', 1);
		setObjX('uberkidDies', dadPos[1]);
		
		playAnim('uberkidDies', 'death', true);
	
		micThrown(false, m);
	end
end

throwUpTime = 0.5;
backTime = 0.7;
micHeight = 200;
function micThrown(back, high) -- throws the mic up / brings it back down
	local toPos = (back and (445 * upScale) or (micHeight * upScale));
	local thrownTime = (back and backTime or throwUpTime);
	local micEase = (back and 'quadIn' or 'quadOut');
	
	if not back then setObjAlpha('microSpin', 1); end
	cancelTween('micThrown');
	doTweenY('micThrown', 'microSpin', toPos, thrownTime / playbackRate, micEase);
end

reappearTime = 0.3;
function reappearUber(t)
	if canRespawn then
		t = t or reappearTime;
		setObjAlpha('uberkidRuns', 1);
		setObjX('uberkidRuns', -140 * upScale);
		
		doTweenX('kidRunsIn', 'uberkidRuns', 214 * upScale, t / playbackRate, 'quadOut');
	end
end

ontoBus = false;
function busUberkid()
	ontoBus = true;
	
	doSound('uberHit', 0.45);
	
	setObjAlpha('runOverUber', 1);
	
	setObjAlpha('dadGroup', 0.00001);
	uberDead = true;
end

function killBus()
	ontoBus = false;
	removeLuaSprite('runOverUber');
end

function onEventPushed(n, v1, v2, s)
	if cacheEvents[n] then 
		cacheEvents[n](v1, v2, s); 
		cacheEvents[n] = nil;
	end
end

cacheEvents = {
	['Pico Shoot'] = function()
		makeLuaSprite('microSpin', 'characters/uberkid/microSpin', 213 * upScale, 445 * upScale);
		scaleObject('microSpin', upScale, upScale);
		local micCen = getObjCen('microSpin');
		setProperty('microSpin.offset.x', micCen[1] + (30 * upScale));
		setProperty('microSpin.offset.y', micCen[2] + (62 * upScale));
		setObjectOrder('microSpin', getObjectOrder('dadGroup') + 1);
		setProperty('microSpin.angularVelocity', -20 * 60 * playbackRate);
		setObjAlpha('microSpin', 0.00001);
		
		local deathScale = 0.9396449704142012 * upScale * 0.95;
		makeAnimatedLuaSprite('uberkidDies', 'characters/uberkid/uberkid-shot', dadPos[1], dadPos[2]);
		addAnimationByPrefix('uberkidDies', 'death', 'UberKidDies', 24, false); -- 24
		addAnimationByPrefix('uberkidDies', 'grab', 'UberKidGrabbed', 28, false);
		scaleObject('uberkidDies', deathScale, deathScale);
		addOffset('uberkidDies', 'death', 461 * deathScale, 78 * deathScale);
		setObjFrameRate('uberkidDies', 'grab', 28.8);
		playAnim('uberkidDies', 'death', true);
		setObjectOrder('uberkidDies', getObjectOrder('dadGroup') + 1);
		setObjAlpha('uberkidDies', 0.00001);
		uberKidFinAnim('uberkidDies');
		
		local uberRunScale = 1.05263157 * upScale;
		makeAnimatedLuaSprite('uberkidRuns', 'characters/uberkid/uberkid-run', (214) * upScale, 670 * upScale); -- -140 to 214 ( + 100 ?????? )
		addAnimationByPrefix('uberkidRuns', 'run', 'UberKidRun', 13);
		scaleObject('uberkidRuns', uberRunScale, uberRunScale);
		local uberRunCen = getObjCen('uberkidRuns');
		addOffset('uberkidRuns', 'run', uberRunCen[1] + (130 * upScale), uberRunCen[2] + (380 * upScale));
		setObjFrameRate('uberkidRuns', 'run', 13.2);
		playAnim('uberkidRuns', 'run', true);
		setObjectOrder('uberkidRuns', getObjectOrder('dadGroup'));
		setObjAlpha('uberkidRuns', 0.00001);
		
		runTimer('resetPullTimer', 0.75 / playbackRate, 0);
	end,
	['Bus Run In'] = function()
		local runOverScale = 0.98979591 * upScale;
		makeLuaSprite('runOverUber', 'characters/uberkid/UberKidRunOver', 321 * upScale, (341 + 135) * upScale); -- 135
		scaleObject('runOverUber', runOverScale, runOverScale);
		local runCen = getObjCen('runOverUber');
		setProperty('runOverUber.offset.x', runCen[1] + (145 * upScale));
		setProperty('runOverUber.offset.y', runCen[2] + (194 * upScale));
		setObjectOrder('runOverUber', getObjectOrder('bus') + 1);
		setObjAlpha('runOverUber', 0.00001);
	end,
	['Final Scene Prep'] = function()
		local uberScale = 1.09702970 * upScale;
		makeAnimatedLuaSprite('uberPunch', 'characters/uberkid/uberkid-punch', dadPos[1], dadPos[2]);
		addAnimationByPrefix('uberPunch', 'gonnaPunch', 'UberKidGonnaPunch', 22, false);
		addAnimationByPrefix('uberPunch', 'micAlone', 'UberKidMicAlone', 0, false);
		scaleObject('uberPunch', uberScale, uberScale);
		addOffset('uberPunch', 'gonnaPunch', 28 * uberScale, 2 * uberScale);
		addOffset('uberPunch', 'micAlone', 28 * uberScale, 2 * uberScale);
		setObjFrameRate('uberPunch', 'gonnaPunch', 22.8);
		playAnim('uberPunch', 'gonnaPunch', true);
		setObjectOrder('uberPunch', getObjectOrder('dadGroup'));
		setObjAlpha('uberPunch', 0.00001);
	end
}

function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Pico Shoot'] = function()
		killKid();
	end,
	['Kill Uberkid'] = function()
		micHeight = -100;
		throwUpTime = 0.4;
		canRespawn = false;
		killKid(true);
	end,
	['Epic Part End'] = function()
		backTime = 0.5;
		canRespawn = true;
		reappearTime = 0.5;
		reappearUber();
	end,
	['Final Scene Prep'] = function()
		setObjAlpha('dadGroup', 0.00001);
		
		setObjAlpha('uberPunch', 1);
		playAnim('uberPunch', 'gonnaPunch', true);
	end,
	['Final Scene'] = function()
		playAnim('uberPunch', 'micAlone', true);
	end
}

function uberkidFinishAnim(o, n)
	if uberFinAnims[o] then uberFinAnims[o](n); end
end

uberFinAnims = {
	['uberkidDies'] = function(n)
		if uberDead then
			if n == 'death' then
				setObjX('uberkidDies', 197 * upScale);
				playAnim('uberkidDies', 'grab', true);
				
				if canRespawn then
					micThrown(true); 
					
					runTimer('runUber', 0.5 / playbackRate);
				end
			end
			if n == 'grab' then
				beingPulled = true;
			end
		end
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['resetPullTimer'] = function()
		uberPullAmount = 8;
	end,
	['runUber'] = function()
		reappearUber();
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['kidRunsIn'] = function()
		setObjAlpha('microSpin', 0.00001);
		setObjAlpha('uberkidRuns', 0.00001);
		setObjAlpha('dadGroup', 1);
		
		uberDead = false;
	end
}
