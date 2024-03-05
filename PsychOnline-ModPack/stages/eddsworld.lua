upScale = 1 / 0.7;
cloudX = 0;
function onCreate()
	luaDebugMode = true;
	
	widthOff = ((640 / 0.7) - 640);
	heightOff = ((360 / 0.7) - 360);
	
	local skyOff = subScrollPos(0.22);
	makeLuaSprite('sky', 'eddsworld/sky', ((667 - math.floor(2000 * 0.8) + (283 * 0.8)) * upScale) + skyOff[1], ((370 - math.floor(1143 * 0.8)) * upScale) + skyOff[2]);
	scaleObject('sky', upScale * 0.8, upScale * 0.8);
	setScrollFactor('sky', 0.22, 0.22);
	addLuaSprite('sky'); -- when the sky is regenerated after tord gets hit, its x pos changes to 668
	
	local cloudsOff = subScrollPos(0.16);
	cloudX = ((177 - 1367 + 119) * upScale) + cloudsOff[1];
	makeLuaSprite('clouds', 'eddsworld/clouds', cloudX, ((34 - 236 + 75) * upScale) + cloudsOff[2]);
	scaleObject('clouds', upScale, upScale);
	setScrollFactor('clouds', 0.16, 0.16);
	addLuaSprite('clouds');
	
	addLuaScript('extraScripts/plane');
	
	local paraOff = subScrollPos(0.73);
	makeLuaSprite('secParallax', 'eddsworld/secParallax', ((410 - 1321) * upScale) + paraOff[1], ((599 - 491) * upScale) + paraOff[2]);
	scaleObject('secParallax', upScale, upScale);
	setScrollFactor('secParallax', 0.73, 0.73);
	addLuaSprite('secParallax');
	
	makeLuaSprite('houses', 'eddsworld/house', (684 - 1743) * upScale, (698 - 1099 + 224) * upScale);
	scaleObject('houses', upScale, upScale);
	addLuaSprite('houses');
	
	makeLuaSprite('fence', 'eddsworld/fence', (684 - 1743 + 441) * upScale, (698 - 1099 + 660) * upScale);
	scaleObject('fence', upScale, upScale);
	addLuaSprite('fence');
	
	addLuaScript('scriptChars/matt');
	
	if songName:find('BORES') then
		addLuaScript('scriptChars/tom');
		addLuaScript('scriptchars/eduardo');
		
		makeLuaSprite('bgColorTweener');
	elseif songName:find('Mix') then
		addLuaScript('extraScripts/tordObjects');
	end
	
	local carOff = subScrollPos(1.3);
	makeLuaSprite('car', 'eddsworld/car', ((-400 - 835) * upScale) + carOff[1], ((694 - 200) * upScale) + carOff[2]);
	scaleObject('car', upScale, upScale);
	setScrollFactor('car', 1.3, 1.3);
	addLuaSprite('car', true);
end

function onCreatePost()
	defaultScreenPos = {(screenWidth / 2) + ((640 / 0.7) - 640), (screenHeight / 2) + ((360 / 0.7) - 360)};
	setCamFollow(defaultScreenPos[1], defaultScreenPos[2]);
	
	setProperty('camGame.scroll.x', ((640 / 0.7) - 640));
	setProperty('camGame.scroll.y', ((360 / 0.7) - 360));
	
	cameraSetTarget('dad');
end

function onUpdatePost(e)
	e = e * playbackRate;
	
	setObjX('clouds', cloudX + (((getSongPosition() / 1000) * (1 / 0.34)) * upScale));
	
	updateBGColor();
	
	updateTord(e);
end

function updateBGColor()
	if bgColorChange then
		local gameZoom = math.floor(getObjX('bgColorTweener'));
		local colorTo = 255 + math.floor(gameZoom / 2);
		local tweeningColor = RGBToHex({colorTo, colorTo, colorTo});
		
		setObjectColor('sky', tweeningColor);
		setObjectColor('clouds', tweeningColor);
		setObjectColor('secParallax', tweeningColor);
	end
end

tordShake = false;
shakeDimEnd = true;
shakeEnd = 15;

explosionShake = false;
explosionAmount = 17;
function updateTord(e)
	if tordShake then
		if shakeDimEnd then
			shakeEnd = shakeEnd - (e / 0.06);
			if shakeEnd <= 4 then 
				shakeDimEnd = false;
				shakeEnd = 4; 
			end
		end
		cameraShake('game', shakeEnd / 640, 0.1 / playbackRate);
	end
	
	if explosionShake then
		explosionAmount = explosionAmount - (e / 0.06);
		if explosionAmount <= 0 then 
			explosionAmount = 0;
			explosionShake = true;
		end
		cameraShake('game', explosionAmount / 640, 0.1 / playbackRate);
	end
end

wellZooms = {
	['1'] = {zoom = 0.7284, tweenTime = 0.15, colorBG = -50, camSub = 12, camOffset = 15.7},
	['2'] = {zoom = 0.7593, tweenTime = 0.15, colorBG = -100, camSub = 25, camOffset = 30},
	['3'] = {zoom = 0.7929, tweenTime = 0.15, colorBG = -150, camSub = 37, camOffset = 47},
	['r'] = {zoom = 0.7, tweenTime = 0.5, colorBG = 0, camSub = 0, camOffset = 0},
}

firstWell = true;
bgColorChange = false;
function onEvent(n, v1, v2)
	if events[n] then events[n](v1); end
end

events = {
	['Change Health Bar Colors'] = function(v1)
		reloadHealthBar();
	end,
	['Cam To Eduardo'] = function(v1)
		cameraSetTarget('dad');
		
		local tweenTime = (v1 == 'true' and 2 or 0.64) / playbackRate;
		local pan = {defaultScreenPos[1] - (-(-475 - 567) * upScale), defaultScreenPos[2] - ((18 + 68) * upScale)};
		
		startTween('cameraEduardoSpecial', 'camGame.scroll', {x = pan[1] - (screenWidth / 2), y = pan[2] - (screenHeight / 2)}, tweenTime, {ease = 'quadOut'});
		
		setProperty('cameraSpeed', 0);
		setProperty('isCameraOnForcedPos', true);
	end,
	['Well'] = function(v1)
		local returning = (v1 == 'r');
		
		wellCamera(v1, returning);
	end,
	['Cancel Bg Color'] = function()
		cancelTween('bgColorZoom');
		setObjX('bgColorTweener', 0);
		
		updateBGColor();
		bgColorChange = false;
	end,
	
	['TordBot Cam Follow'] = function()
		local pan = {defaultScreenPos[1] - (-15 * upScale), defaultScreenPos[2] - (700 * upScale)};
		
		startTween('cameraToTordBot', 'camGame.scroll', {x = pan[1] - (screenWidth / 2), y = pan[2] - (screenHeight / 2)}, 5 / playbackRate, {ease = 'quadInOut'});
		setCamFollow(pan[1], pan[2]);
		
		setProperty('camGame.followLerp', 0);
		setProperty('cameraSpeed', 0);
		setProperty('isCameraOnForcedPos', true);
		inTord = true;
	end,
	['TordBot Zoom'] = function(v1)
		local zoomTo = tonumber(v1)
		if zoomTbl[zoomTo] then
			zoomTbl[zoomTo]();
		end
	end,
	['Tord Ending'] = function(v1)
		if v1 == 'hit' then
			tordShake = true;
			shakeEnd = 15;
		end
	end,
	['TordBot Explode'] = function()
		explosionShake = true;
	end,
	['Ending Pan Down'] = function()
		local pan = {defaultScreenPos[1] - (-15 * upScale), defaultScreenPos[2]};
		
		startTween('cameraDown', 'camGame.scroll', {x = pan[1] - (screenWidth / 2), y = pan[2] - (screenHeight / 2)}, 5.2 / playbackRate, {ease = 'quadOut'});
		setCamFollow(pan[1], pan[2]);
		
		setProperty('camGame.followLerp', 0);
		setProperty('cameraSpeed', 0);
		setProperty('isCameraOnForcedPos', true);
	end
}

zoomTbl = {
	[0] = function() --zoom out
		setProperty('doCamZooms', false);
		alphGlass = true;
		
		doTweenZoom('tordOutOfPit', 'camGame', 64 / 89, 0.2 / playbackRate, 'quadIn');
		setProperty('defaultCamZoom', 64 / 89);
	end,
	[1] = function() --zoom in
		setProperty('doCamZooms', false);
		
		local pan = {defaultScreenPos[1] - ((-15 + 30) * upScale), defaultScreenPos[2] - ((700 + 375) * upScale) + 370};
		
		startTween('camIntoTord', 'camGame', {
			['scroll.x'] = pan[1] - (screenWidth / 2), 
			['scroll.y'] = pan[2] - (screenHeight / 2), 
			zoom = 1.82
		}, 0.5 / playbackRate, {
			ease = 'quintIn', 
			onComplete = 'onTweenCompleted'
		});
		setCamFollow(pan[1], pan[2]);
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['goBackSlow'] = function()
		cancelTween('zoomInEduardoR');
		
		wellCamera('r', true, 2);
	end
}

inTord = false;
function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['zoomInEduardoR'] = function()
		setProperty('cameraSpeed', 1);
		setProperty('isCameraOnForcedPos', false);
		setProperty('doCamZooms', true);
		setProperty('camZooming', true);
	end,
	['camIntoTord'] = function()
		stageShow();
		
		setProperty('camGame.zoom', 64 / 89);
		
		doTweenZoom('tordIntoPit', 'camGame', 1, 0.2 / playbackRate, 'quadOut');
		setProperty('defaultCamZoom', 1);
	end,
	['tordIntoPit'] = function()
		setProperty('doCamZooms', true);
		setProperty('camZooming', true);
	end,
	['tordOutOfPit'] = function()
		tordShake = false;
		cameraShake('game', 0, 0.00001);
		
		stageShow();
		
		local pan = {defaultScreenPos[1] - (-15 * upScale), defaultScreenPos[2] - (700 * upScale)};
		
		setProperty('camGame.zoom', 1.82);
		startTween('tordZoomOut', 'camGame', {
			['scroll.x'] = pan[1] - (screenWidth / 2), 
			['scroll.y'] = pan[2] - (screenHeight / 2), 
			zoom = 0.7
		}, 0.5 / playbackRate, {
			ease = 'quintOut',
			onComplete = 'onTweenCompleted'
		});
		
		setProperty('defaultCamZoom', 0.7);
	end,
	['tordZoomOut'] = function()
		inTord = false;
		setProperty('doCamZooms', true);
		setProperty('camZooming', true);
	end
}

firstReturn = true;
function wellCamera(w, r, t)
	local well = wellZooms[w];
	
	local easeZoom = (r and 'quadOut' or 'backOut');
	local easeTime = (t or well.tweenTime) / playbackRate;
	local pan = {defaultScreenPos[1] - (-(-475 - 567) * upScale), defaultScreenPos[2] - ((18 + 68 + well.camSub) * upScale) + well.camOffset};
	
	if firstWell then
		firstWell = false;
		bgColorChange = true;
		
		setVar('doCamZooms', false);
	end
	
	if r and firstReturn then
		firstReturn = false;
		
		runTimer('goBackSlow', 0.15 / playbackRate);
	end
	
	cancelTween('bgColorZoom');
	doTweenX('bgColorZoom', 'bgColorTweener', well.colorBG, easeTime, easeZoom);
	
	startTween('zoomInEduardo' .. w:upper(), 'camGame', {
		['scroll.x'] = pan[1] - (screenWidth / 2),
		['scroll.y'] = pan[2] - (screenHeight / 2),
		zoom = well.zoom
	}, easeTime, {
		ease = easeZoom,
		onComplete = 'onTweenCompleted'
	});
	setCamFollow(pan[1], pan[2]);
	setProperty('defaultCamZoom', well.zoom);
end

showing = true;
function stageShow()
	showing = not showing;
	local alp = (showing and 1 or 0);
	
	setObjAlpha('sky', alp);
	setObjAlpha('clouds', alp);
	setObjAlpha('secParallax', alp);
	setObjAlpha('tordBot', alp);
	setObjAlpha('houses', alp);
end

setZoom = true;
camPositioned = false;
function onGameOver()
	if setZoom then
		setZoom = false;
		
		setProperty('defaultCamZoom', 0.7);
		setProperty('camGame.zoom', 0.7);
	end
	
	if not camPositioned and inTord then
		local pan = {defaultScreenPos[1] - (-15 * upScale), defaultScreenPos[2] - (700 * upScale)};
		setProperty('camGame.scroll.x', pan[1] - (screenWidth / 2));
		setProperty('camGame.scroll.y', pan[2] - (screenWidth / 2));
	end
	camPositioned = true;
end

function math.lerp(a, b, ratio) return a + ratio * (b - a); end

function RGBToHex(t)
    return tonumber(string.format('0x00%.2x%.2x%.2x', t[1], t[2], t[3])); 
end
