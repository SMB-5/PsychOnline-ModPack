upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		createGlobalCallback('updateFade', function(?p) {
			parentLua.call('fadeUpdate', [p]);
		});
	]]);

	local skyOff = subScrollPos(0.1);
	makeLuaSprite('sky', 'nevada/sky', ((667 - math.floor(876 * 0.8)) * upScale) + skyOff[1], ((370 - math.floor(689 * 0.8)) * upScale) + skyOff[2]);
	scaleObject('sky', 0.8 * upScale, 0.8 * upScale);
	setScrollFactor('sky', 0.1, 0.1);
	addLuaSprite('sky'); 
	
	local cliffOff = subScrollPos(0.5);
	makeLuaSprite('cliff', 'nevada/cliffs', ((782 - 936) * upScale) + cliffOff[1], ((537 - 737 + 143) * upScale) + cliffOff[2]);
	setScrollFactor('cliff', 0.5, 0.5);
	scaleObject('cliff', upScale, upScale);
	addLuaSprite('cliff');
	
	makeLuaSprite('ground', 'nevada/ground', (684 - 982) * upScale, (698 - 995 + 727) * upScale);
	scaleObject('ground', upScale, upScale);
	addLuaSprite('ground');
	
	local dogStandOff = subScrollPos(1.41);
	makeLuaSprite('dogStand', 'nevada/hotDogStand', ((370 - math.floor(770 * 0.88) + (49 * 0.88)) * upScale) + dogStandOff[1], ((37 - math.floor(255 * 0.88) + (682 * 0.88)) * upScale) + dogStandOff[2]);
	scaleObject('dogStand', 0.88 * upScale, 0.88 * upScale);
	setScrollFactor('dogStand', 1.41, 1.41);
	setProperty('dogStand.color', getColorFromHex('976666'));
	addLuaSprite('dogStand', true);
end

function onCreatePost()
	defaultScreenPos = {(screenWidth / 2) + ((640 / 0.7) - 640), (screenHeight / 2) + ((360 / 0.7) - 360)};
	setCamFollow(defaultScreenPos[1], defaultScreenPos[2]);
	
	setProperty('camGame.scroll.x', ((640 / 0.7) - 640));
	setProperty('camGame.scroll.y', ((360 / 0.7) - 360));
	
	cameraSetTarget('dad');
end

function onUpdatePost()
	if stopCamZooming and not inGameOver then
		setProperty('camZooming', false);
	end
end

tweenColors = {255, 255, 254};
tweenColorsTo = {255, 193, 194};
function fadeUpdate(p)
	local newColors = {};
	for i = 1, 3 do
		newColors[i] = math.floor(math.lerp(tweenColors[i], tweenColorsTo[i], p));
	end
	
	local redColor = RGBToHex(newColors);
	
	setObjectColor('ground', redColor);
	setObjectColor('boyfriendGroup', redColor);
	setHankColors(redColor);
	if luaSpriteExists('gfHotdog') then setObjectColor('gfHotdog', redColor); end
end

stopCamZooming = false;
zoomTweened = false;
function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Hank Ready Up'] = function()
		local pan = {defaultScreenPos[1] - (170 * upScale), defaultScreenPos[2] - (-38 * upScale)}; -- for the Y it would be -48 BUT the zoom makes it so that you can see the bottom of the fg
		local zoomTo = 0.76;
		
		startTween('camToHank', 'camGame', {['scroll.x'] = pan[1] - (screenWidth / 2), ['scroll.y'] = pan[2] - (screenHeight / 2), zoom = zoomTo}, 0.8 / playbackRate, {ease = 'quadOut'});
		setCamFollow(pan[1], pan[2]);
		setProperty('defaultCamZoom', zoomTo);
		
		setProperty('cameraSpeed', 0);
		
		setProperty('isCameraOnForcedPos', true);
	end,
	['Ready Zoom Out'] = function()
		cancelTween('camToHank');
		cameraSetTarget('dad');
		
		local camTo = getCamFollow();
		local zoomTo = 0.7;
		
		startTween('camBackHank', 'camGame', {['scroll.x'] = camTo[1] - (screenWidth / 2), ['scroll.y'] = camTo[2] - (screenHeight / 2), zoom = 0.7}, 0.2 / playbackRate, 
		{
			ease = 'quadOut', 
			onComplete = 'onTweenCompleted'
		});
		setProperty('defaultCamZoom', zoomTo);
	end,
	['GF Hands Up'] = function()
		playAnim('gf', 'raiseHands', true);
		setProperty('gf.skipDance', true);
		
		runTimer('goToHandsUpGF', 0.06 / playbackRate);
	end,
	['Deimos And Sanford Fall'] = function()
		setProperty('boyfriendCameraOffset[1]', getProperty('boyfriendCameraOffset[1]') - (59 * upScale));
		setProperty('opponentCameraOffset[1]', getProperty('opponentCameraOffset[1]') - (59 * upScale));
		
		local pan = {defaultScreenPos[1], defaultScreenPos[2] - (125 * upScale)};
		
		startTween('camMoving', 'camGame', {['scroll.x'] = pan[1] - (screenWidth / 2), ['scroll.y'] = pan[2] - (screenHeight / 2)}, 0.8 / playbackRate, {ease = 'quadOut'});
		setCamFollow(pan[1], pan[2]);
		
		setProperty('cameraSpeed', 0);
		
		setProperty('isCameraOnForcedPos', true);
	end,
	['Cam Back BF'] = function()
		cancelTween('camMoving');
		if zoomTweened then
			zoomTweened = false;
			
			doTweenZoom('camZoomDefault', 'camGame', 0.7, 2.5 / playbackRate, 'quadOut');
			setProperty('defaultCamZoom', 0.7);
			stopCamZooming = true;
		end
		
		cameraSetTarget('bf');
		
		local camTo = getCamFollow();
		startTween('camBackBF', 'camGame', {['scroll.x'] = camTo[1] - (screenWidth / 2), ['scroll.y'] = camTo[2] - (screenHeight / 2)}, 2.5 / playbackRate, 
		{
			ease = 'quadOut', 
			onComplete = 'onTweenCompleted'
		});
		setCamFollow(camTo[1], camTo[2]);
	end,
	['Camera To Tricky'] = function(v1)
		if v1 == 'true' then
			local zoomTo = 0.76;
			
			doTweenZoom('camZoomDefault', 'camGame', zoomTo, 0.2 / playbackRate, 'quadOut');
			setProperty('defaultCamZoom', zoomTo);
			zoomTweened = true;
			
			runTimer('camBackTicky', 1.8 / playbackRate);
		end
		local pan = {defaultScreenPos[1], defaultScreenPos[2] - (139 * upScale)};
		
		startTween('camMoving', 'camGame', {['scroll.x'] = pan[1] - (screenWidth / 2), ['scroll.y'] = pan[2] - (screenHeight / 2)}, 0.2 / playbackRate, {ease = 'quadOut'});
		setCamFollow(pan[1], pan[2]);
		
		setProperty('cameraSpeed', 0);
		
		setProperty('isCameraOnForcedPos', true);
	end,
	['Hank Shoot Scared'] = function()
		cameraSetTarget('dad');
		
		local camTo = getCamFollow();
		startTween('camBackHank', 'camGame', {['scroll.x'] = camTo[1] - (screenWidth / 2), ['scroll.y'] = camTo[2] - (screenHeight / 2)}, 2.5 / playbackRate, 
		{
			ease = 'quadOut', 
			onComplete = 'onTweenCompleted'
		});
		setCamFollow(camTo[1], camTo[2]);
	end,
	['Camera To Hellclown'] = function() -- 91697
		setProperty('boyfriendCameraOffset[1]', getProperty('boyfriendCameraOffset[1]') - (42 * upScale));
		setProperty('opponentCameraOffset[1]', getProperty('opponentCameraOffset[1]') - (42 * upScale));
		
		local pan = {defaultScreenPos[1], defaultScreenPos[2] - (125 * upScale)};
		
		startTween('camMoving', 'camGame', {['scroll.x'] = pan[1] - (screenWidth / 2), ['scroll.y'] = pan[2] - (screenHeight / 2)}, 3.5 / playbackRate, {ease = 'quadOut'});
		setCamFollow(pan[1], pan[2]);
		
		setProperty('cameraSpeed', 0);
		
		setProperty('isCameraOnForcedPos', true);
		
		runTimer('backToHank', 7.632 / playbackRate);
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['goToHandsUpGF'] = function()
		setProperty('gf.skipDance', false);
		characterDance('gf');
	end,
	['camBackTicky'] = function()
		local newY = defaultScreenPos[2] - (103 * upScale);
		setProperty('camFollow.y', newY);
		doTweenY('downCamTricky', 'camGame.scroll', newY - (screenHeight / 2), 2.5 / playbackRate, 'quadOut');
	end,
	['backToHank'] = function()
		cameraSetTarget('dad');
		
		local camTo = getCamFollow();
		startTween('camBackHank', 'camGame', {['scroll.x'] = camTo[1] - (screenWidth / 2), ['scroll.y'] = camTo[2] - (screenHeight / 2)}, 2.5 / playbackRate, 
		{
			ease = 'quadOut', 
			onComplete = 'onTweenCompleted'
		});
		setCamFollow(camTo[1], camTo[2]);
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['camBackHank'] = function()
		setProperty('cameraSpeed', 1);
		setProperty('isCameraOnForcedPos', false);
	end,
	['camBackBF'] = function()
		setProperty('cameraSpeed', 1);
		setProperty('isCameraOnForcedPos', false);
		if stopCamZooming then
			stopCamZooming = false;
			setProperty('camZooming', true);
		end
	end
}

function math.lerp(a, b, ratio) return a + ratio * (b - a); end

function RGBToHex(tabl)
    return tonumber(string.format('0x00%.2x%.2x%.2x', tabl[1], tabl[2], tabl[3])); 
end