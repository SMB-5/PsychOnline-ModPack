upScale = 1 / 0.7;
hankScale = 0.61428571 * upScale * 1.12;
dadPos = {};
function onCreate()
	luaDebugMode = true;
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		createGlobalCallback('hankDoShoot', function(d) {
			parentLua.call('hankShoot', [d]);
		});
		
		createGlobalCallback('setHankColors', function(c) {
			parentLua.call('hankColorsTo', [c]);
		});
		
		createCallback('setObjFinAnim', function(o, f) {
			var b = LuaUtils.getObjectDirectly(o, false);
			
			b.animation.finishCallback = function(n) {
				parentLua.call(f, [o, n]);
			}
		});
	]]);
	
	setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') + 1);
	
	scaleObject('dad', hankScale, hankScale);
	resizeOffsets('dad', hankScale);

	makeAnimatedLuaSprite('hankShoot', 'characters/hank/hank-shoot', getProperty('dad.x'), getProperty('dad.y'));
	addAnimationByPrefix('hankShoot', 'shootLEFT', 'Hank Left Shoot', 30);
	addAnimationByPrefix('hankShoot', 'shootDOWN', 'Hank Down Shoot', 30);
	addAnimationByPrefix('hankShoot', 'shootUP', 'Hank Up shoot', 30);
	addAnimationByPrefix('hankShoot', 'shootRIGHT', 'Hank right shoot', 30);
	scaleObject('hankShoot', hankScale, hankScale);
	addOffset('hankShoot', 'shootLEFT', 57 * hankScale, 38 * hankScale);
	addOffset('hankShoot', 'shootDOWN', 67.5 * hankScale, 43.5 * hankScale);
	addOffset('hankShoot', 'shootUP', 12 * hankScale, 33 * hankScale);
	addOffset('hankShoot', 'shootRIGHT', -9.8 * upScale, 7.5 * upScale);
	setLoopPoint('hankShoot', 'shootLEFT', 9);
	setLoopPoint('hankShoot', 'shootDOWN', 9);
	setLoopPoint('hankShoot', 'shootUP', 9);
	setLoopPoint('hankShoot', 'shootRIGHT', 4);
	playAnim('hankShoot', 'shootLEFT', true);
	setObjectOrder('hankShoot', getObjectOrder('dadGroup'));
	setObjAlpha('hankShoot', 0.00001);
	
	makeLuaSprite('shotRay', 'characters/hank/ray', 611 * upScale, 358 * upScale);
	scaleObject('shotRay', upScale, upScale);
	setObjectOrder('shotRay', getObjectOrder('dadGroup') + 1);
	setObjAlpha('shotRay', 0.00001);
	
	singAnims = getProperty('singAnimations');
	
	dadPos = getObjPos('dad');
end

function onEventPushed(n, v1, v2, s)
	if cacheEvents[n] then 
		cacheEvents[n](v1, v2, s); 
		cacheEvents[n] = nil;
	end
end

cacheEvents = {
	['Hank Ready Up'] = function()
		local readyUpScale = 0.62708719 * upScale * 1.12;
		
		makeAnimatedLuaSprite('hankReadyUp', 'characters/hank/hank-readyUp', dadPos[1], dadPos[2]);
		addAnimationByPrefix('hankReadyUp', 'spinKnife', 'HankGetReady', 30, false);
		scaleObject('hankReadyUp', readyUpScale, readyUpScale);
		addOffset('hankReadyUp', 'spinKnife', 8 * readyUpScale, -7 * readyUpScale);
		playAnim('hankReadyUp', 'spinKnife', true);
		setObjectOrder('hankReadyUp', getObjectOrder('dadGroup'));
		setObjAlpha('hankReadyUp', 0.00001);
		setObjFinAnim('hankReadyUp', 'hankReadyUpFin');
		
		precacheSound('hankreadyupsond');
	end,
	['Hank Scared'] = function()
		makeAnimatedLuaSprite('hankScared', 'characters/hank/hank-scared', dadPos[1], dadPos[2]);
		addAnimationByPrefix('hankScared', 'idle', 'HankScaredIdle', 18);
		addAnimationByPrefix('hankScared', 'shoot', 'HankScaredShootsTiky', 24, false);
		scaleObject('hankScared', hankScale, hankScale);
		addOffset('hankScared', 'idle', 13 * hankScale, -31 * hankScale);
		addOffset('hankScared', 'shoot', 105 * hankScale, 397 * hankScale);
		setLoopPoint('hankScared', 'idle', 8);
		playAnim('hankScared', 'idle', true);
		setObjectOrder('hankScared', getObjectOrder('dadGroup'));
		setObjAlpha('hankScared', 0.00001);
	end,
	['Hank Scream'] = function()
		local screamScale = 0.69230769 * upScale * 1.05;
		makeAnimatedLuaSprite('hankScreams', 'characters/hank/hank-scream', dadPos[1], dadPos[2]);
		addAnimationByPrefix('hankScreams', 'scream', 'Hank screamright', 29);
		scaleObject('hankScreams', screamScale, screamScale);
		addOffset('hankScreams', 'scream', 79 * screamScale, -39 * screamScale);
		setObjFrameRate('hankScreams', 'scream', 28.8);
		setLoopPoint('hankScreams', 'scream', 7);
		playAnim('hankScreams', 'scream', true);
		setObjectOrder('hankScreams', getObjectOrder('dadGroup'));
		setObjAlpha('hankScreams', 0.00001);
	end
}

function hankReadyUpFin()
	if checkReadyUp then
		checkReadyUp = false;
		
		removeLuaSprite('hankReadyUp');
		
		setObjAlpha('dadGroup', 1);
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		if hankIsScared then
			scaredHankDance();
		end
	end
end

scaredHankIdle = true;
function scaredHankDance()
	if scaredHankIdle then playAnim('hankScared', 'idle', true); end
end

function hankColorsTo(c)
	setObjectColor('dadGroup', c);
	setObjectColor('hankShoot', c);
	setObjectColor('hankScreams', c);
end

singAnims = {};
tweenShot = false;
trickShot = true;
trickDieTime = 0;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if not inGameOver then
		if not trickShot then
			trickDieTime = trickDieTime + e;
			if trickDieTime >= 0.02 then
				trickShot = true;
				
				killTricky();
			end
		end
		
		if shotAlpha > 0.00001 then
			shotAlpha = shotAlpha - ((1 - blendCoeff(30)) * (e * 60));
			if shotAlpha < 0.00001 then
				shotAlpha = 0.00001;
			end
			setObjAlpha('shotRay', shotAlpha);
		end
		
		if isShooting then
			shootTimer = shootTimer - (e * 60);
			if shootTimer < 0 then
				hideShoot();
			end
		end
		
		if doingHold then
			holdHankT = holdHankT + e;
			if holdHankT >= (stepCrochet / 2000) then
				playAnim('dad', singAnims[curDir + 1], true);
				doingHold = false;
			end
		end
	end
end

function hideShoot()
	isShooting = false;
	
	setObjAlpha('hankShoot', 0.00001);
	setObjAlpha('dadGroup', 1);
end

shootAnims = {
	[0] = 'shootLEFT',
	'shootDOWN',
	'shootUP',
	'shootRIGHT'
};
shootTimer = 0;
shotAlpha = 0;
function hankShoot(d)
	shotAlpha = 1;
	
	isShooting = true;
	noteAffect = false;
	playAnim('hankShoot', shootAnims[d], true);
	
	setObjAlpha('hankShoot', 1);
	setObjAlpha('dadGroup', 0.00001);
	
	shootTimer = 15;
end

curDir = 0;
holdHankT = 0;
doingHold = false;
noteAffect = false;
isShooting = false;
function opponentNoteHit(i, d, n, s)
	if n == '' then
		if s then
			curDir = d;
			doingHold = true;
			holdHankT = 0;
		end
	end
end

hankIsScared = false;
screaming = false;
function onEvent(n)
	if events[n] then
		events[n]();
	end
end

events = {
	['Hank Ready Up'] = function()
		checkReadyUp = true;
		
		playAnim('hankReadyUp', 'spinKnife', true);
		setObjAlpha('hankReadyUp', 1);
		
		setObjAlpha('dadGroup', 0.00001);
		
		doSound('hankreadyupsond', 0.22);
	end,
	['Hank Scared'] = function()
		hankIsScared = not hankIsScared;
		
		setObjAlpha('dadGroup', hankIsScared and 0.00001 or 1);
		setObjAlpha('hankScared', hankIsScared and 1 or 0.00001);
	end,
	['Hank Shoot Scared'] = function()
		trickDieTime = 0;
		trickShot = false;
		
		scaredHankIdle = false;
		playAnim('hankScared', 'shoot', true);
	end,
	['Hank Scream'] = function()
		screaming = not screaming;
		
		setObjAlpha('dadGroup', screaming and 0.00001 or 1);
		setObjAlpha('hankScreams', screaming and 1 or 0.00001);
		
		if screaming then playAnim('hankScreams', 'scream', true); end
	end
}
