upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	runHaxeCode([[
		import psychlua.LuaUtils;
		
		createCallback('curObjFrameChange', function(o) {
			LuaUtils.getObjectDirectly(o, false).animation.callback = function(n, f) {
				parentLua.call('objChangeframe', [o, f]);
			}
		});
		
		createCallback('objFinAnim', function(o) {
			var b = LuaUtils.getObjectDirectly(o);
			b.animation.finishCallback = function(n) {
				if (b.alpha > 0.00001)
					parentLua.call('objFinishAnim', [o, n]);
			}
		});
	]]);
	
	makeAnimatedLuaSprite('smokeCache', 'fx/intro/smoke');
	setScrollFactor('smokeCache');
	addLuaSprite('smokeCache');
	setObjAlpha('smokeCache', 0.00001);
	
	local fatKidScale = 1.03759398 * upScale;
	makeAnimatedLuaSprite('fatKidIntro', 'interactables/fatkid/fatKidIntro', 1145 * upScale, 357 * upScale);
	addAnimationByPrefix('fatKidIntro', 'iceCream', 'fatkidicecreamlick', 12);
	addAnimationByPrefix('fatKidIntro', 'react', 'fatkidreacts', 15, false);
	addAnimationByPrefix('fatKidIntro', 'lookDown', 'fatkidlooks', 28, false);
	addAnimationByPrefix('fatKidIntro', 'transition', 'fatkidtransition', 12, false);
	scaleObject('fatKidIntro', fatKidScale, fatKidScale);
	local kidCen = getObjCen('fatKidIntro');
	for i, anim in pairs({'iceCream', 'react', 'lookDown', 'transition'}) do
		addOffset('fatKidIntro', anim, kidCen[1] + (137 * upScale), kidCen[2] + (173 * upScale));
	end
	setObjFrameRate('fatKidIntro', 'lookDown', 28.8);
	playAnim('fatKidIntro', 'iceCream', true);
	setObjectOrder('fatKidIntro', getObjectOrder('fatKid'));
	
	addLuaScript('introScripts/bfGfIntro');
	addLuaScript('introScripts/fbiTruck');
	addLuaScript('introScripts/agentShip');
	
	makeAnimatedLuaSprite('shipFire', 'fx/intro/shipFire', 200, 200);
	addAnimationByPrefix('shipFire', 'fire', 'ShipFire', 16);
	scaleObject('shipFire', upScale, upScale);
	local fireCen = getObjCen('shipFire');
	addOffset('shipFire', 'fire', fireCen[1] + (254 * upScale), fireCen[2] + (292 * upScale));
	setObjFrameRate('shipFire', 'fire', 16.8);
	playAnim('shipFire', 'fire', true);
	addLuaSprite('shipFire', true);
	setObjAlpha('shipFire', 0.00001);
	
	local deathScale = 0.72575250 * upScale;
	makeLuaSprite('deadAlien', 'characters/alien/alien-dead', 304 * upScale, 354 * upScale);
	scaleObject('deadAlien', deathScale, deathScale);
	addToOffsets('deadAlien', 173 * upScale, 271 * upScale);
	addLuaSprite('deadAlien', true);
	setObjAlpha('deadAlien', 0.00001);
	
	local shipScale = 0.72693266 * upScale;
	makeAnimatedLuaSprite('alienShip', 'characters/alien/alien-introShip', 200 * upScale, 200 * upScale);
	addAnimationByPrefix('alienShip', 'ship', 'AlienOnShip', 30);
	scaleObject('alienShip', shipScale, shipScale);
	local shipCen = getObjCen('alienShip');
	addOffset('alienShip', 'ship', shipCen[1] + (291 * upScale), shipCen[2] + (193 * upScale));
	playAnim('alienShip', 'ship', true);
	addLuaSprite('alienShip', true);
	setObjAlpha('alienShip', 0.00001);
	
	local shipScale = 1.03703703 * upScale;
	makeLuaSprite('ship', 'fx/intro/shipAlone', 340 * upScale, 391 * upScale);
	scaleObject('ship', shipScale, shipScale);
	addToOffsets('ship', 277 * upScale, 156 * upScale);
	addLuaSprite('ship', true);
	setObjAlpha('ship', 0.00001);
	
	local exploScale = 1.03897685 * upScale;
	makeAnimatedLuaSprite('shipExplosion', 'fx/explosion', 408 * upScale, 386 * upScale);
	addAnimationByPrefix('shipExplosion', 'explode', 'BOOM!', 24, false);
	scaleObject('shipExplosion', exploScale, exploScale);
	local cen = getObjCen('shipExplosion');
	addOffset('shipExplosion', 'explode', cen[1] + (426 * upScale), cen[2] + (434 * upScale));
	playAnim('shipExplosion', 'explode', true);
	addLuaSprite('shipExplosion', true);
	setObjAlpha('shipExplosion', 0.00001);
	
	makeLuaSprite('smokeShipLayer');
	addLuaSprite('smokeShipLayer', true);
	setObjAlpha('smokeShipLayer', 0);
	
	local aliScale = 0.74701411 * upScale;
	makeAnimatedLuaSprite('alienSplat', 'characters/alien/alien-introSplat', 405 * upScale, 583 * upScale);
	addAnimationByPrefix('alienSplat', 'faceSlap', 'HominidFacePlanted', 15, false);
	addAnimationByPrefix('alienSplat', 'getUp', 'Hominidgetsup', 28, false);
	scaleObject('alienSplat', aliScale, aliScale);
	local slapCen = getObjCen('alienSplat');
	addOffset('alienSplat', 'faceSlap', slapCen[1] + (252 * upScale), slapCen[2] + (434 * upScale));
	addOffset('alienSplat', 'getUp', slapCen[1] + (312 * upScale), slapCen[2] + (301 * upScale));
	setObjFrameRate('alienSplat', 'getUp', 28.8);
	playAnim('alienSplat', 'faceSlap', true);
	addLuaSprite('alienSplat', true);
	setObjAlpha('alienSplat', 0.00001);
	
	addLuaScript('introScripts/agentClean');
	
	local gaspScale = 0.97121212 * upScale;
	makeAnimatedLuaSprite('agentGasp', 'agent/intro/gaspAgent', 1074 * upScale, 670 * upScale);
	addAnimationByPrefix('agentGasp', 'gasp', 'GASP agent', 13, false);
	scaleObject('agentGasp', gaspScale, gaspScale);
	local gaspCen = getObjCen('agentGasp');
	addOffset('agentGasp', 'gasp', gaspCen[1] + (320 * upScale), gaspCen[2] + (278 * upScale));
	setObjFrameRate('agentGasp', 'gasp', 13.2);
	playAnim('agentGasp', 'gasp', true);
	addLuaSprite('agentGasp', true);
	setObjAlpha('agentGasp', 0.00001);
end

soundsCache = {
	'fall ship',
	'alien fall',
	'head pull up',
	'ship explo',
	'car loop mega extended',
	'grabbing ship',
	'ship woosh',
	'ship hit car',
	'glasses down',
	'walking noises',
	'enter arm',
	'exit arm',
	'bf fall'
}
function onCreatePost()
	for i = 1, #soundsCache do 
		precacheSound('intro/' .. soundsCache[i]);
	end
	
	setObjAlpha('dadGroup', 0.00001);
	setProperty('isCameraOnForcedPos', true);
end

canStart = false;
started = false;
function onStartCountdown()
	if not started then
		started = true;
		runTimer('killCache', 0.25 / playbackRate);
		runTimer('fallAlien', 2.2 / playbackRate);
		setProperty('inCutscene', true);
	end
	
	if not canStart then return Function_Stop; end
	
	return function_continue;
end

function destroyCache()
	removeLuaScript('introScripts/bfGfIntro');
	removeLuaScript('introScripts/fbiTruck');
	removeLuaScript('introScripts/agentShip');
	removeLuaScript('introScripts/agentClean');
end

firing = true;
alienThrown = false;
aliVals = {
	frontShip = false,
	fallSpd = -35,
	fallMult = 2
}
function onUpdatePost(e)
	e = e * playbackRate;
	
	local constNum = (e * 60);
	
	if firing then
		local shipPos = getObjPos('alienShip');
		setObjPos('shipFire', shipPos[1] + (-66 * upScale), shipPos[2] + (-123 * upScale));
	end
	
	if alienThrown then
		addToPos('deadAlien', 3 * upScale * constNum, aliVals.fallSpd * upScale * constNum);
		aliVals.fallSpd = aliVals.fallSpd + (aliVals.fallMult * constNum);
		
		if not aliVals.frontShip and aliVals.fallSpd > 0 then
			aliVals.frontShip = true;
			
			setObjectOrder('deadAlien', getObjectOrder('ship'));
		end
		
		if getObjY('deadAlien') > (500 * upScale) then
			alienThrown = false;
			doSound('intro/alien fall');
			
			setObjAlpha('alienSplat', 1);
			playAnim('alienSplat', 'faceSlap', true);
			
			removeLuaSprite('deadAlien');
			
			runTimer('agentsComeIn', 1.15 / playbackRate);
		end
	end
end

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['killCache'] = function()
		if not getVar('unCached') then
			setVar('unCached', true);
			callOnLuas('destroyCache', {});
		end
	end,
	['fallAlien'] = function()
		doSound('intro/fall ship');
		
		setObjAlpha('shipFire', 1);
		setObjAlpha('alienShip', 1);
		setObjPos('alienShip', -250 * upScale, -273 * upScale);
		startTween('shipCrash', 'alienShip', {x = (340 * upScale), y = (391 * upScale)}, 0.5 / playbackRate, {ease = 'QuadIn', onComplete = 'onTweenCompleted'});
		runTimer('smokeShip', 0.1 / playbackRate, 0);
	end,
	['smokeShip'] = function()
		smoke(getObjX('alienShip') - (54 * upScale), getObjY('alienShip') - (59 * upScale), getObjectOrder('alienShip') - 1);
	end,
	['groundShipSmoke'] = function()
		smoke(
			getObjX('alienShip') + ((-54 + getRandomInt(-200, 50)) * upScale), 
			getObjY('alienShip') + ((-59 + getRandomInt(-200, 20)) * upScale), 
			getObjectOrder('smokeShipLayer') + 1
		);
	end,
	['truckShipSmoke'] = function()
		smoke(
			getObjX('fbiTruck') + ((-262 + getRandomInt(-300, 50)) * upScale), 
			getObjY('fbiTruck') + ((-18 + getRandomInt(-100, 20)) * upScale), 
			getObjectOrder('smokeTruckLayer')
		);
	end,
	['fatKidLook'] = function()
		playAnim('fatKidIntro', 'lookDown', true);
	end,
	['agentsComeIn'] = function()
		doSound('intro/head pull up', 0.5);
		
		setObjectOrder('agentGasp', getObjectOrder('fgBuildGrpS') + 1);
		setObjAlpha('agentGasp', 1);
		playAnim('agentGasp', 'gasp', true);
		removeObjOnFinishAnim('agentGasp');
		
		runTimer('agentCutscene', 0.5 / playbackRate);
		
		onChangeFrame('agentGasp', function(f)
			if f >= 19 then
				doSound('intro/glasses down', 0.5);
				
				return true;
			end
			return false;
		end);
	end,
	['pickUpShip'] = function()
		removeLuaSprite('ship');
	end,
	['debugCut'] = function()
		playAnim('fatKidIntro', 'transition', true);
		objFinAnim('fatKidIntro');
		
		playAnim('alienSplat', 'getUp', true);
		objFinAnim('alienSplat');
	end,
	['beginSong'] = function()
		callOnLuas('destroyIntro', {});
		
		canStart = true;
		startCountdown();
		setProperty('isCameraOnForcedPos', false);
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['shipCrash'] = function()
		firing = false;
		doSound('intro/ship explo');
		
		alienThrown = true;
		setObjAlpha('alienShip', 0);
		setObjAlpha('iceCream', 1);
		setObjAlpha('streetCRACK', 1);
		setObjAlpha('ship', 1);
		setObjAlpha('deadAlien', 1);
		setObjAlpha('shipExplosion', 1);
		
		playAnim('fatKidIntro', 'react', true);
		playAnim('iceCream', 'fall', true);
		
		setObjPos('shipFire', 350 * upScale, 296 * upScale);
		scaleObject('shipFire', upScale * 0.7, upScale * 0.7);
		resizeOffsets('shipFire', 0.7);
		doTweenAlpha('shipDim', 'shipFire', 0, 0.2125 / playbackRate);
		
		playAnim('shipExplosion', 'explode', true);
		removeObjOnFinishAnim('shipExplosion');
		
		cameraShake('game', 3 / 640, 0.31 / playbackRate);
		
		runTimer('fatKidLook', 1 / playbackRate);
		runTimer('groundShipSmoke', 0.15 / playbackRate, 5);
		cancelTimer('smokeShip');
	end,
	['shipDim'] = function()
		removeLuaSprite('shipFire');
	end
}

totSmoke = 0;
smokeScale = 1 * upScale;
function smoke(x, y, o)
	totSmoke = totSmoke + 1;
	local t = 'shipSmoke' .. totSmoke;
	makeAnimatedLuaSprite(t, 'fx/intro/smoke', x, y);
	addAnimationByPrefix(t, 'smoke', 'Smoke', 18, false);
	scaleObject(t, smokeScale, smokeScale);
	local cen = getObjCen(t);
	addOffset(t, 'smoke', cen[1] + (184 * upScale), cen[2] + (169 * upScale));
	playAnim(t, 'smoke', true);
	setObjectOrder(t, o);
	removeObjOnFinishAnim(t);
end

function stealCream()
	runTimer('debugCut', 1 / playbackRate);
end

function objFinishAnim(n)
	if finAnims[n] then finAnims[n](); end
end

finAnims = {
	['alienSplat'] = function()
		setObjAlpha('dadGroup', 1);
		characterDance('dad');
		
		removeLuaSprite('alienSplat');
	end,
	['fatKidIntro'] = function()
		setObjAlpha('fatKid', 1);
		playAnim('fatKid', 'idleA', true);
		
		removeLuaSprite('fatKidIntro');
	end
}

function onChangeFrame(grp, f)
	curObjFrameChange(grp);
	funcsForGrp[grp] = f;
end

function objChangeframe(o, f)
	if funcsForGrp[o] and funcsForGrp[o](f) then
		funcsForGrp[o] = nil;
	end
end

funcsForGrp = {};

function destroyIntro()
	removeLuaSprite('smokeCache');
	removeLuaSprite('smokeShipLayer');
	removeLuaSprite('alienShip');
end
