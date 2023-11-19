upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	carScale = 0.91814947 * upScale;
	
	makeAnimatedLuaSprite('carEvil', 'cars/tankEvil');
	addAnimationByPrefix('carEvil', 'idle', 'VehicleTankBad');
	setProperty('carEvil.animation.curAnim.loopPoint', 3);
	scaleObject('carEvil', carScale, carScale);
	playAnim('carEvil', 'idle', true);
	addLuaSprite('carEvil', true);
	setProperty('carEvil.alpha', 0.00001);
	
	makeAnimatedLuaSprite('pultCarEvil', 'cars/carObjects/tankPult', 0, -300);
	addAnimationByPrefix('pultCarEvil', 'idle', 'ThrowingThingTHROW0001', 0);
	addAnimationByPrefix('pultCarEvil', 'throw', 'ThrowingThingTHROW', 29, false);
	scaleObject('pultCarEvil', carScale, carScale);
	addOffset('pultCarEvil', 'idle', 0, 0);
	addOffset('pultCarEvil', 'throw', 0, 0);
	playAnim('pultCarEvil', 'idle', true);
	setObjectOrder('pultCarEvil', getObjectOrder('carEvil') - 1);
	setProperty('pultCarEvil.alpha', 0.00001);
	
	addLuaScript('scriptChars/tankChumpFootball');
	
	makeLuaSprite('tankMover2', nil, -2100 * upScale, -152 * upScale);
	
	makeLuaSprite('dadCamAdjust');
	
	runHaxeCode([[
		var carEv = game.modchartSprites.get('carEvil');
		
		carEv.animation.callback = function(n, f) {
			parentLua.call('onFrameChangeCEv', [n, f]);
		}
		
		createCallback('setObjPos', function(o:String, x:Float, y:Float) {	
			if (o == 'dad') {
				var sp = game.dadGroup;
				sp.x = x;
				sp.y = y;
			} else {
				var sp = game.modchartSprites.get(o);
				sp.x = x;
				sp.y = y;
			}
		});
		
		createCallback('getObjXY', function(b:String) {
			var h = game.modchartSprites.get(b);
			return [h.x, h.y];
		});
	]]);
end

function onCreatePost()
	setObjectOrder('dadGroup', getObjectOrder('carEvil') - 1);
end

function throwPult()
	playAnim('pultCarEvil', 'throw', true);
	
	callScript('scriptChars/tankChumpFootball', 'pullLever');
	
	runTimer('runCanon', 1.5 / playbackRate);
end

YoffPos = 0;
function onFrameChangeCEv(n, f)
	if frameYAdjust[n] then
		if frameYAdjust[n][f] then YoffPos = frameYAdjust[n][f]; end
	end
end

frameYAdjust = {
	['idle'] = {
		[0] = 0,
		[1] = 4,
		[2] = 5,
		[3] = 4,
		[4] = 0,
		[5] = 4,
		[6] = 5
	}
}

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('carEvil', 'idle', true);
	end
end

canAdjustPos = false;
truckAdjustPos = false;
function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Tanks Drive In'] = function()
		runTimer('truckDriveIn', 0.2 / playbackRate);
	end,
	['Tanks Slow In'] = function()
		setProperty('tankMover2.y', (-152 * upScale) - (5 * upScale));
		cancelTween('carEvilDriveInX');
		cancelTween('slowInTruckX');
		doTweenX('slowInTruckX', 'tankMover2', ((-2099 + 6327) * upScale) + (getRandomInt(0, 100) * upScale), 2 / playbackRate, 'sineout');
	end,
	['Tank Can Adjust'] = function()
		canAdjustPos = not canAdjustPos;
	end,
	['Car Evil Can Adjust'] = function()
		canAdjustPos = not canAdjustPos;
	end,
	['Chump Car RAM!!'] = function(v1, v2)
		chumpCarRam((v1 == 'true'), (v2 == 'true'));
	end,
	['Tanks Run Skittles'] = function()
		cancelTween('dadCamPosAdjustX');
		cancelTween('truckAdjustPosX');
		canAdjustPos = false;
		
		setProperty('tankMover2.x', getProperty('tankMover2.x') + (8000 * upScale));
		doTweenX('truckRunInSkitX', 'tankMover2', getProperty('skittleHut.x') - (1073 * upScale), 0.5 / playbackRate);
	end,
	['Tank Skid'] = function(v1)
		if v1 == 'skid' then
			cancelTween('dadCamPosAdjustX');
			cancelTween('truckAdjustPosX');
			
			canAdjustPos = false;
			doTweenX('carFallBack', 'tankMover2', getProperty('tankMover2.x') - (2000 * upScale), 1 / playbackRate, 'quartout');
		end
	end
}

bigRam = false;
returRam = false;
function chumpCarRam(isBigRam, isReturning)
	cancelTween('dadCamPosAdjustX');
	cancelTween('truckAdjustPosX');
	
	cancelTween('carRam');
	cancelTween('carRamBack');
	
	canAdjustPos = false;
	bigRam = isBigRam;
	returRam = isReturning;
	local moveAmount = (isBigRam and (200 * upScale) or (100 * upScale));
	doTweenX('dadCamPosAdjustX', 'dadCamAdjust', getProperty('dadCamAdjust.x') + moveAmount, 0.35 / playbackRate, 'sinein');
	doTweenX('carRam', 'tankMover2', getProperty('tankMover2.x') + moveAmount, 0.35 / playbackRate, 'sinein');
end

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['truckDriveIn'] = function()
		truckActive = true;
		setProperty('carEvil.alpha', 1);
		setProperty('dad.alpha', 1);
		setProperty('footballChump.alpha', 1);
		setProperty('pultCarEvil.alpha', 1);
		
		doTweenX('carEvilDriveInX', 'tankMover2', ((-2099 + 6327) * upScale) + (getRandomInt(0, 100) * upScale), 1 / playbackRate);
	end,
	['adjustTankPosit'] = function()
		adjustTruckPos();
	end,
	['runCanon'] = function()
		playAnim('pultCarEvil', 'throw', true, true);
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['truckRunInSkitX'] = function()
		canAdjustPos = true;
		adjustTruckPos();
	end,
	['carRam'] = function()
		local moveAmount = (returRam and (200 * upScale) or (100 * upScale));
		doTweenX('dadCamPosAdjustX', 'dadCamAdjust', getProperty('dadCamAdjust.x') - moveAmount, (returRam and 1.8 or 0.4) / playbackRate, 'expoout');
		doTweenX('carRamBack', 'tankMover2', getProperty('tankMover2.x') - moveAmount, (returRam and 1.8 or 0.4) / playbackRate, 'expoout');
		
		cameraShake('game', 0.005, 0.25 / playbackRate);
		local hitAmount = (50 * upScale);
		
		cancelTween('bfCamPosAdjustX');
		cancelTween('tankAdjustPosX');
		cancelTween('tankHitBackX');
		if not bigRam then
			setProperty('bfCamAdjust.x', getProperty('bfCamAdjust.x') + hitAmount);
			setProperty('tankMover.x', getProperty('tankMover.x') + hitAmount);
		end
		doTweenX('bfCamPosAdjustX', 'bfCamAdjust', getProperty('bfCamAdjust.x') - hitAmount, 0.4 / playbackRate, 'expoout');
		doTweenX('tankHitBackX', 'tankMover', getProperty('tankMover.x') - hitAmount, 0.4 / playbackRate, 'expoout');
	end
}

function adjustTruckPos()
	if canAdjustPos then
		cancelTween('dadCamPosAdjustX');
		cancelTween('truckAdjustPosX');
		adjustAmount = (getRandomInt(0, 100) * upScale);
		doTweenX('dadCamPosAdjustX', 'dadCamAdjust', adjustAmount, 2 / playbackRate, 'sineout');
		doTweenX('truckAdjustPosX', 'tankMover2', (-2099 * upScale) + ((getProperty('tankAdjustAmount') + 327) * upScale) + adjustAmount, 2 / playbackRate, 'sineout');
	end
end

finCheck = false;
truckActive = false;
function onUpdatePost(e)
	e = e * playbackRate;
	if not inGameOver then
		if truckActive then
			if canAdjustPos and tankAdjustTime(e) then
				adjustTruckPos();
			end
			
			local truckPos = getObjXY('tankMover2');
			local yOff = (YoffPos * upScale);
			
			setObjPos('carEvil', truckPos[1], truckPos[2]);
			
			setObjPos('pultCarEvil', truckPos[1] + (110 * upScale), truckPos[2] - (333 * upScale));
			
			setObjPos('dad', truckPos[1] + (882 * upScale), truckPos[2] - (188 * upScale) + yOff);
			
			setObjPos('footballChump', truckPos[1] + (1205 * upScale), truckPos[2] - (101 * upScale) + yOff);
			
			setProperty('opponentCameraOffset[0]', -getProperty('dadCamAdjust.x'));
			setProperty('opponentCameraOffset[1]', -yOff);
		end
	end
end

adjustPos = 0;
function tankAdjustTime(e)
	local prevAdjustPos = adjustPos;
	adjustPos = (adjustPos + e) % 2; -- 2 seconds
	
	return (prevAdjustPos > adjustPos);
end