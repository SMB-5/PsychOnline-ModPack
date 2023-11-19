upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	tankScale = 0.91836735 * upScale;
	
	smokeScale = 1.08087535 * upScale;
	
	makeAnimatedLuaSprite('tank', 'cars/tank', 0, -50 * upScale);
	addAnimationByPrefix('tank', 'drive', 'Tank', 18);
	scaleObject('tank', tankScale, tankScale);
	playAnim('tank', 'drive', true);
	addLuaSprite('tank', true);
	setProperty('tank.alpha', 0.00001);
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		setVar("tankAdjustAmount", 6000);
		
		game.modchartSprites.get('tank').animation.callback = function(_, f) {
			parentLua.call('onTankFChange', [f]);
		}
		
		createCallback('setObjPos', function(o:String, x:Float, y:Float) {	
			if (o == 'boyfriend') {
				var sp = game.boyfriendGroup;
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
		
		createCallback('addFinCallback', function(o) {
			var anim = LuaUtils.getObjectDirectly(o, false).animation;
			
			anim.finishCallback = function(n) {
				parentLua.call('onExplosionFin', [o]);
			}
		});
		
		createCallback('setObjVelX', function(o:String, v:Float) {
			return LuaUtils.getObjectDirectly(o, false).velocity.x = v;
		});
	]]);
	
	addLuaScript('scriptChars/steve');
	
	addLuaScript('extraScripts/tankSkid');
	
	makeLuaSprite('tankMover', nil, -1742 * upScale, -451 * upScale);
	
	makeLuaSprite('bfCamAdjust');
	
	--runTimer('adjustTankPosit', 2 / playbackRate, 0);
end

function onCreatePost()
	setObjectOrder('boyfriendGroup', getObjectOrder('tank') + 1);
end

totExplosions = 0;
explosionGrp = {};
function ballExplode()
	totExplosions = totExplosions + 1;
	local t = 'ballExplosion' .. totExplosions;
	makeAnimatedLuaSprite(t, 'cars/carObjects/cannonball', getProperty('tank.x') - (141 * upScale), -355 * upScale);
	addAnimationByPrefix(t, 'explode', 'ballexplosion', 29, false);
	scaleObject(t, smokeScale, smokeScale);
	playAnim(t, 'explode', true);
	setProperty(t .. '.animation.curAnim.frameRate', 28.8);
	setObjectOrder(t, (getRandomBool(50) and getObjectOrder('floor') + 1 or getObjectOrder('floorF') - 1));
	
	addFinCallback(t);
	
	table.insert(explosionGrp, {
		t = t
	});
end

function onExplosionFin(n)
	removeLuaSprite(n);
end

tankActive = false;
adjustPx = 0;
function onTankFChange(f)
	adjustPx = tankOffPos[f] * upScale;
end

tankOffPos = {
	[0] = 0,
	[1] = 4,
	[2] = 5
}

attachedToMover = false;
function onUpdatePost(e)
	e = e * playbackRate;

	if not inGameOver then
		if tankActive then
			if canAdjustPos and tankAdjustTime(e) then
				adjustTankPos();
			end
			
			local moverPos = getObjXY('tankMover');
			setObjPos('tank', moverPos[1], moverPos[2]);
			
			setObjPos('tankSteve', moverPos[1] + (284 * upScale), moverPos[2] - (103 * upScale) + adjustPx);
			
			setObjPos('boyfriend', moverPos[1] + (78 * upScale), moverPos[2] - (101 * upScale) + adjustPx);
			
			setProperty('boyfriendCameraOffset[0]', -getProperty('bfCamAdjust.x'));
			setProperty('boyfriendCameraOffset[1]', -adjustPx);
		end
		
		if #explosionGrp > 0 then
			local moveSpd = -17 * getProperty('bgSpeed');
			for i = 1, #explosionGrp do
				local cont = true;
				local curPld = explosionGrp[i];
				if curPld then
					if not luaSpriteExists(curPld.t) then
						table.remove(explosionGrp, i);
						
						cont = false;
					end
					if cont then setObjVelX(curPld.t, moveSpd); end
				end
			end
		end
	end
end

adjustPos = 0;
function tankAdjustTime(e)
	local prevAdjustPos = adjustPos;
	adjustPos = (adjustPos + e) % 2; -- 2 seconds
	
	return (prevAdjustPos > adjustPos);
end

YoffPos = {
	['idle'] = {
		[0] = 0,
		[1] = 3,
		[2] = 4
	}
}

canAdjustPos = false;
slowingIn = false;
function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Tanks Drive In'] = function()
		tankActive = true;
		setProperty('tank.alpha', 1);
		setProperty('tankSteve.alpha', 1);
		setProperty('boyfriend.alpha', 1);
		doTweenX('tankDriveInX', 'tankMover', (-1742 + 7658) * upScale, 1 / playbackRate); -- 6982
		doTweenY('tankDriveInY', 'tankMover', (-428 + 442 - 13) * upScale, 1 / playbackRate);
		runTimer('tankShake', 0.1);
	end,
	['Tanks Slow In'] = function()
		if not slowingIn then
			slowingIn = true;
			cancelTween('tankDriveInX');
			cancelTween('slowInTankX');
			doTweenX('slowInTankX', 'tankMover', (-1742 + 7658) * upScale, 1 / playbackRate, 'quadout');
		end
	end,
	['Tank Can Adjust'] = function()
		canAdjustPos = not canAdjustPos;
	end,
	['Tank Behind Truck'] = function()
		tankBehindTruck();
	end,
	['Tanks Run Skittles'] = function()
		cancelTween('bfCamPosAdjustX');
		cancelTween('tankAdjustPosX');
		canAdjustPos = false;
		setProperty('tankMover.x', getProperty('tankMover.x') + (8000 * upScale));
		doTweenX('tankRunInSkitX', 'tankMover', getProperty('skittleHut.x') + (273 * upScale), 0.5 / playbackRate);
	end,
	['Tank Skid'] = function()
		setProperty('tankSteve.alpha', 0.00001);
		setProperty('tank.alpha', 0.00001);
		setProperty('boyfriend.alpha', 0.00001);
		tankActive = false;
		canAdjustPos = false;
		cancelTween('bfCamPosAdjustX');
		cancelTween('tankAdjustPosX');
	end,
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['tankShake'] = function()
		cameraShake('game', 0.005, 0.55 / playbackRate);
	end,
	['adjustTankPosit'] = function()
		adjustTankPos();
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['tankRunInSkitX'] = function()
		setProperty('tankAdjustAmount', 22000);
		
		canAdjustPos = true;
		adjustTankPos();
	end,
	['carRam'] = function()
		canAdjustPos = false;
	end
}	

function adjustTankPos()
	if canAdjustPos then
		cancelTween('bfCamPosAdjustX');
		cancelTween('tankAdjustPosX');
		adjustAmount = (getRandomInt(-40, 40) * upScale)
		doTweenX('bfCamPosAdjustX', 'bfCamAdjust', adjustAmount, 2 / playbackRate, 'sineout');
		doTweenX('tankAdjustPosX', 'tankMover', ((-1742 + 1658) * upScale) + (getProperty('tankAdjustAmount') * upScale) + adjustAmount, 2 / playbackRate, 'sineout');
	end
end

isBehind = false;
function tankBehindTruck()
	isBehind = not isBehind;
	
	if isBehind then
		setObjectOrder('boyfriendGroup', (getObjectOrder('floor') + 1));
		setObjectOrder('tank', (getObjectOrder('floor') + 1));
		setObjectOrder('tankSteve', (getObjectOrder('floor') + 1));
	else
		setObjectOrder('tankSteve', getObjectOrder('floorF') - 2);
		setObjectOrder('tank', getObjectOrder('floorF') - 2);
		setObjectOrder('boyfriendGroup', getObjectOrder('floorF') - 2);
	end
end