upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		createCallback('makeBackDropX', function(t:String, img:String, x:Float, y:Float) {
			var bgSprite = new FlxBackdrop(Paths.image(img), 1);
			bgSprite.x = x;
			bgSprite.y = y;
			bgSprite.antialiasing = ClientPrefs.data.antialiasing;
			setVar(t, bgSprite);
		});
		
		createCallback('setObjVelX', function(o:String, v:Float) {
			return LuaUtils.getObjectDirectly(o, false).velocity.x = v;
		});
		
		createCallback('moveCam', function() {
			game.moveCameraSection();
		});
		
		setVar("bgSpeed", 0);
		setVar("spawnRateBG", 0);
		setVar("killChance", 0);
	]]);
	
	makeLuaSprite('sky', 'wasteland/sky', (667 - 913) * upScale, (374 - 560) * upScale);
	scaleObject('sky', upScale * 0.8, upScale * 0.8);
	setScrollFactor('sky', 0, 0);
	addLuaSprite('sky');
	
	makeBackDropX('clouds', 'wasteland/clouds', 1389 * upScale, -313 * upScale);
	scaleObject('clouds', upScale, upScale);
	setScrollFactor('clouds', 0.05, 0.05);
	addInstance('clouds');
	
	makeBackDropX('mountains', 'wasteland/mountains', 432 * upScale, 99 * upScale);
	scaleObject('mountains', upScale, upScale);
	setScrollFactor('mountains', 0.1, 0.1);
	addInstance('mountains');
	
	makeBackDropX('city', 'wasteland/city', 372 * upScale, -22 * upScale);
	scaleObject('city', upScale, upScale);
	setScrollFactor('city', 0.2, 0.2);
	addInstance('city');
	
	makeBackDropX('battleField', 'wasteland/battlefield', 688 * upScale, 135 * upScale);
	scaleObject('battleField', upScale, upScale);
	setScrollFactor('battleField', 0.4, 0.4);
	addInstance('battleField');
	
	makeLuaSprite('starDest', 'wasteland/objectEvents/bar/starDestroyer', 275 * upScale, 23 * upScale);
	scaleObject('starDest', upScale, upScale);
	setScrollFactor('starDest', 0.4, 0.4);
	addLuaSprite('starDest');
	
	if not lowQuality then addLuaScript('extraScripts/battlersBG'); end
	
	makeBackDropX('floor', 'wasteland/floor', 719 * upScale, 57 * upScale);
	scaleObject('floor', upScale, upScale);
	setObjectOrder('floor', 2000);
	
	addLuaScript('scriptChars/skittles');
	
	addLuaScript('cars/carEvil');
	addLuaScript('cars/tank');
	
	makeLuaSprite('tableGuys', 'wasteland/objectEvents/bar/tableguys', 290 * upScale, -55 * upScale);
	scaleObject('tableGuys', upScale, upScale);
	setScrollFactor('tableGuys', 1.1, 1.1);
	addLuaSprite('tableGuys', true);
	
	makeBackDropX('floorF', 'wasteland/floor2', 750 * upScale, 119 * upScale);
	scaleObject('floorF', upScale, upScale);
	setScrollFactor('floorF', 1.4, 1.4);
	addInstance('floorF', true);
	setProperty('floorF.color', getColorFromHex('d7bf7c'));
	
	makeLuaSprite('store', 'wasteland/objectEvents/bar/store', 0, -616 * upScale);
	scaleObject('store', upScale, upScale);
	setScrollFactor('store', 1.5, 1.5);
	addLuaSprite('store', true);
	setProperty('store.alpha', 0.00001);
	
	addLuaScript('scriptChars/tankLady');
end

function onCreatePost()
	setProperty('isCameraOnForcedPos', true);
	
	setProperty('camFollow.x', 0);
	setProperty('camFollow.y', 0);
	setProperty('camGame.scroll.x', -screenWidth / 2);
	setProperty('camGame.scroll.y', -screenHeight / 2);
	
	setProperty('dad.alpha', 0.00001);
	setProperty('boyfriend.alpha', 0.00001);
end

function onSongStart()
	setProperty('store.alpha', 1);
	setProperty('store.x', 676 * upScale);
end

bgVelMult = 0;
bgVelSpeed = 0;
camEdge = 0;
daSpeed = 0;
bgMove = {'clouds', 'mountains', 'city', 'battleField', 'floor', 'floorF'};
moveMult = {0.5, 1, 1.5, 5, 17, 30};
checkOvlimit = true;
stopCamLerp = false;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if not inGameOver then
		if stopCamLerp then 
			setProperty('camGame.followLerp', 0); 
		elseif not getProperty('isCameraOnForcedPos') then 
			moveCam(); 
		end
		
		if bgVelMult ~= 0 then
			if bgVelMult == 1 and bgVelSpeed < 100 or bgVelMult == -1 and bgVelSpeed > 0 then
				bgVelSpeed = bgVelSpeed + (5 * bgVelMult * e * 60);
			end
			
			if bgVelMult == -2 and bgVelSpeed > 0 then 
				bgVelSpeed = bgVelSpeed + ((bgVelMult + 1) * e * 60)
			end
			
			if checkOvlimit and bgVelSpeed > 100 then bgVelSpeed = 100; end
			
			if bgVelSpeed < 0 then bgVelSpeed = 0; end
			
			daSpeed = ((bgVelSpeed / 100) * upScale) * 60 * playbackRate;
			setProperty('bgSpeed', daSpeed);
		end
		
		for i = 1, #bgMove do
			setObjVelX(bgMove[i], -moveMult[i] * daSpeed);
		end
	end
end

function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Pan To Bar'] = function()
		stopCamLerp = true;
		setProperty('camGame.followLerp', 0);
		
		startTween('panBar', 'camGame', {
			['scroll.x'] = (1300 * upScale) - (screenWidth / 2)
		}, 5 / playbackRate, {
			ease = 'quadInOut', 
			onComplete = 'onTweenCompleted'
		});
		
		setProperty('camFollow.x', (1300 * upScale));
	end,
	['Follow Cars'] = function()
		stopCamLerp = true;
		setProperty('camGame.followLerp', 0);
		
		startTween('folTanks', 'camGame.scroll', {
			x = (5500 * upScale) - (screenWidth / 2), 
			y = (-229 * upScale) - (screenHeight / 2)
		}, 2 / playbackRate, {
			ease = 'cubeInOut', 
			onComplete = 'onTweenCompleted'
		});
		
		setProperty('camFollow.x', 5500 * upScale);
		setProperty('camFollow.y', -229 * upScale);
	end,
	['Bg Velocity Start'] = function()
		bgVelMult = 1;
	end,
	['Bg Velocity Stop'] = function(v1, v2)
		bgVelMult = (v1 == 'true' and -2 or -1);
		if v2 == 'true' then checkOvlimit = false; bgVelSpeed = 150; end
	end,
	['Set Spawn Rate BG'] = function(v1, v2)
		v1, v2 = tonumber(v1) or 0, tonumber(v2) or 0;
		
		setProperty('spawnRateBG', v1);
		setProperty('killChance', v2);
	end,
	['Pan To Skittles'] = function()
		stopCamLerp = true;
		setProperty('camGame.followLerp', 0);
		
		setProperty('isCameraOnForcedPos', true);
	end,
	['Cam Back Skittles'] = function()
		isDownMove = true;
	end,
	['Pan Tank Ending'] = function()
		setProperty('camGame.followLerp', 0);
		stopCamLerp = true;
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['camBackTruck'] = function()
		cancelTween('movePosToTankPos');
		
		local dadCamPos = (getProperty('tankAdjustAmount') - 350) * upScale;
		local dadY = (-29 - 200) * upScale;
		
		setProperty('camFollow.x', dadCamPos);
		setProperty('camFollow.y', dadY);
		
		startTween('movePosToTankPos2', 'camGame.scroll', {
			x = dadCamPos - (screenWidth / 2), 
			y = dadY - (screenHeight / 2)
		}, 2.5 / playbackRate, {
			ease = 'quadOut',
			onComplete = 'onTweenCompleted'
		});
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['panBar'] = function()
		stopCamLerp = false;
	end,
	['folTanks'] = function()
		destroyIntro();
		
		setProperty('isCameraOnForcedPos', false);
		stopCamLerp = false;
	end,
	['movePosToTankPos2'] = function()
		setProperty('isCameraOnForcedPos', false);
		stopCamLerp = false;
	end
}

isDownMove = false;
function onSectionHit()
	if isDownMove then
		isDownMove = false;
		
		cancelTween('panSkittleDown2PosY');
		
		local bfCamPos = (getProperty('tankAdjustAmount') - 120) * upScale;
		local bfY = 29 * upScale;
		
		setProperty('camFollow.x', bfCamPos);
		setProperty('camFollow.y', bfY);
		
		startTween('movePosToTankPos', 'camGame.scroll', {
			x = bfCamPos - (screenWidth / 2),
			y = bfY - (screenHeight / 2)
		}, 2.5 / playbackRate, {
			ease = 'quadOut'
		});
		runTimer('camBackTruck', 1.2 / playbackRate);
	end
end

function destroyIntro()
	removeLuaSprite('starDest');
	removeLuaSprite('tableGuys');
	
	--removeLuaScript('scriptChars/tankLady'); -- KILL JOHN LENNON
	--removeLuaSprite('tankLady');
	
	removeLuaSprite('store');
end
