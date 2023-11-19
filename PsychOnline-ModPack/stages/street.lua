upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	addHaxeLibrary('FlxCamera', 'flixel');
	runHaxeCode([[
		FlxG.cameras.remove(game.camHUD, false);
		FlxG.cameras.remove(game.camOther, false);
		
		var extrasCam = FlxG.cameras.add(new FlxCamera(), false);
		extrasCam.bgColor = game.camHUD.bgColor;
		
		setVar('camExtra', extrasCam);
		
		FlxG.cameras.add(game.camHUD, false);
		FlxG.cameras.add(game.camOther, false);
		
		createGlobalCallback('setObjectExtrasCam', function(o) {
			LuaUtils.getObjectDirectly(o, false).camera = extrasCam;
		});
	]]);
	
	local skyOffset = subScrollPos(0.1);
	makeLuaSprite('sky', 'street/sky', ((667 - math.floor(1000 * 0.8)) * upScale) + skyOffset[1], ((370 - math.floor(645 * 0.8)) * upScale) + skyOffset[2]);
	scaleObject('sky', upScale * 0.8, upScale * 0.8);
	setScrollFactor('sky', 0.1, 0.1);
	addLuaSprite('sky');
	
	makeLuaSprite('street', 'street/street', (697 - 982 + 159) * upScale, (774 - 995 + 198) * upScale);
	scaleObject('street', upScale, upScale);
	addLuaSprite('street');
	
	addLuaScript('scriptChars/nene');
	addLuaScript('scriptChars/darnell');
	
	addLuaScript('extraScripts/bus');
	
	local uberOffset = subScrollPos(1.41);
	local frontUberScale = 1.098 * upScale;
	makeAnimatedLuaSprite('frontBoppers', 'street/fgUberkids/uberkidsFG', ((597 - 36) * upScale) + uberOffset[1], (779 * upScale) + uberOffset[2]);
	addAnimationByPrefix('frontBoppers', 'idle', 'frontbounce', 14, false);
	scaleObject('frontBoppers', frontUberScale, frontUberScale);
	local uberCen = getObjCen('frontBoppers');
	addOffset('frontBoppers', 'idle', uberCen[1] + (911 * upScale), uberCen[2] + (316 * upScale));
	setObjFrameRate('frontBoppers', 'idle', 14.4);
	playAnim('frontBoppers', 'idle', true);
	setScrollFactor('frontBoppers', 1.41, 1.41);
	addLuaSprite('frontBoppers', true);
	
	addLuaScript('extraScripts/FGKidsRunIn');
	
	if flashingLights then
		makeLuaSprite('shotFlash');
		makeGraphic('shotFlash', 1, 1);
		scaleObject('shotFlash', screenWidth, screenHeight);
		setObjectExtrasCam('shotFlash');
		addLuaSprite('shotFlash');
		setObjAlpha('shotFlash', 0.00001);
		setBlendMode('shotFlash', 'add');
	end
end

function onCreatePost()
	defaultScreenPos = {(screenWidth / 2) + ((640 / 0.7) - 640), (screenHeight / 2) + ((360 / 0.7) - 360)};
	setCamFollow(defaultScreenPos[1], defaultScreenPos[2]);
	
	setProperty('camGame.scroll.x', ((640 / 0.7) - 640));
	setProperty('camGame.scroll.y', ((360 / 0.7) - 360));
	
	cameraSetTarget('dad');
	
	setProperty('gf.origin.y', getProperty('gf.height'));
	setProperty('gf.angle', 1);
end

bopFront = true;
function onBeatHit()
	if bopFront then playAnim('frontBoppers', 'idle', true); end
end

onCountdownTick = onBeatHit;

stopCamZooming = false;
function onUpdatePost()
	if stopCamZooming and not inGameOver then
		setProperty('camZooming', false);
	end
end

function picoDodge()
	local pan = {defaultScreenPos[1] - (-170 * upScale), defaultScreenPos[2] - (-29 * upScale)};
	startTween('picoCamBus', 'camGame', {
		['scroll.x'] = pan[1] - (screenWidth / 2),
		['scroll.y'] = pan[2] - (screenHeight / 2),
	}, 0.8 / playbackRate, {ease = 'quadOut'});
	setCamFollow(pan[1], pan[2]);
	
	setProperty('cameraSpeed', 0);
	setProperty('isCameraOnForcedPos', true);
	
	runTimer('backToPico', 1.74 / playbackRate);
end

doDoin = false;
function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Pico Guns Out'] = function()
		cameraSetTarget('bf');
	end,
	['Pico Shoot'] = function()
		cameraShake('game', 0.007, 0.15 / playbackRate);
		if getProperty('camZooming') then triggerEvent('Add Camera Zoom', '0.06', '0.01'); end
	end,
	['Pico Do Do Zoom'] = function()
		doDoin = not doDoin;
		
		local pan = {defaultScreenPos[1] - (-100 * upScale), defaultScreenPos[2] - (doDoin and (-38 * upScale) or 0)};
		local zoomTo = doDoin and 1.019 or 0.7;
		
		startTween('picoDoDo' .. (doDoin and 'In' or 'Out'), 'camGame', {
			['scroll.x'] = pan[1] - (screenWidth / 2),
			['scroll.y'] = pan[2] - (screenHeight / 2),
			zoom = zoomTo
		}, 0.5 / playbackRate, {ease = 'quadOut', onComplete = 'onTweenCompleted'});
		setCamFollow(pan[1], pan[2]);
		setProperty('defaultCamZoom', zoomTo);
		
		setProperty('cameraSpeed', 0);
		setProperty('isCameraOnForcedPos', true);
		stopCamZooming = true;
	end,
	['Set Up Uberfront'] = function()
		bopFront = false;
		removeLuaSprite('frontBoppers');
	end,
	['Pico Breakdance Shoot'] = function()
		cameraShake('game', 0.007, 0.15 / playbackRate);
		if getProperty('camZooming') then triggerEvent('Add Camera Zoom', '0.06', '0.01'); end
		
		picoCamGlow();
	end,
	['Pico Epic Shoot'] = function()
		cameraShake('game', 0.007, 0.15 / playbackRate);
		if getProperty('camZooming') then triggerEvent('Add Camera Zoom', '0.06', '0.01'); end
		
		picoCamGlow();
	end,
	['Epic Part End'] = function()
		setProperty('cameraSpeed', 1);
		setProperty('isCameraOnForcedPos', false);
	end,
	['Comic Book Appear'] = function()
		runTimer('uberKidPan', 0.355 / playbackRate);
	end,
	['Bus Explosion'] = function()
		cameraShake('game', 0.007, 0.15 / playbackRate);
	end,
	['Pico No Ammo'] = function()
		if getProperty('camZooming') then triggerEvent('Add Camera Zoom', '0.02', '0.01'); end
	end,
	['Final Scene Cam'] = function()
		local pan = {defaultScreenPos[1] - (-120 * upScale), defaultScreenPos[2] - (-29 * upScale)};
		
		startTween('finalCamA', 'camGame.scroll', {x = pan[1] - (screenWidth / 2), y = pan[2] - (screenHeight / 2)}, 0.55 / playbackRate, {ease = 'quadOut', onComplete = 'onTweenCompleted'});
		setCamFollow(pan[1], pan[2]);
		
		setProperty('cameraSpeed', 0);
		setProperty('isCameraOnForcedPos', true);
	end,
	['Final Scene'] = function()
		triggerEvent('Add Camera Zoom', '0.05', '0.025');
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['uberKidPan'] = function()
		cameraSetTarget('dad');
	end,
	['backToPico'] = function()
		setProperty('cameraSpeed', 1);
		setProperty('isCameraOnForcedPos', false);
	
		cameraSetTarget('bf');
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['picoDoDoOut'] = function()
		stopCamZooming = false;
		setProperty('camZooming', true);
	end,
	['finalCamA'] = function()
		local pan = {defaultScreenPos[1], defaultScreenPos[2] - (-29 * upScale)};
		
		startTween('finalCamB', 'camGame.scroll', {x = pan[1] - (screenWidth / 2), y = pan[2] - (screenHeight / 2)}, 0.2 / playbackRate, {ease = 'quadOut'});
		setCamFollow(pan[1], pan[2]);
	end
}

function picoCamGlow()
	cancelTween('flashingShot');
	
	setObjAlpha('shotFlash', 0.4);
	doTweenAlpha('flashingShot', 'shotFlash', 0, (2 / 6) / playbackRate);
end