upScale = 1 / 0.7;
function onCreate()
	runHaxeCode([[
		import psychlua.LuaUtils;
		
		createCallback('curObjFrameChange', function(o) {
			LuaUtils.getObjectDirectly(o, false).animation.callback = function(n, f) {
				parentLua.call('objChangeframe', [o, f]);
			}
		});
	]]);
	
	makeLuaSprite('smokeTruckLayer');
	addLuaSprite('smokeTruckLayer', true);
	setObjAlpha('smokeTruckLayer', 0);
	
	local truckScale = 1.03762662 * upScale;
	makeAnimatedLuaSprite('fbiTruck', 'agent/intro/FBITruck', 500 * upScale, 198 * upScale);
	addAnimationByPrefix('fbiTruck', 'idle', 'FBITruckIDLE', 18);
	addAnimationByPrefix('fbiTruck', 'drive', 'FBITruckDRIVE', 30);
	addAnimationByPrefix('fbiTruck', 'driveAlien', 'FBITruckSHIP', 30);
	addAnimationByPrefix('fbiTruck', 'shipTruck', 'ShipFallsonTruck', 18, false);
	scaleObject('fbiTruck', truckScale, truckScale);
	local truckCen = getObjCen('fbiTruck');
	local truckOff = {truckCen[1] + (717 * upScale), truckCen[2] + (372 * upScale)};
	addOffset('fbiTruck', 'idle', truckOff[1], truckOff[2]);
	addOffset('fbiTruck', 'drive', truckOff[1], truckOff[2]);
	addOffset('fbiTruck', 'driveAlien', truckOff[1], truckOff[2]);
	addOffset('fbiTruck', 'shipTruck', truckCen[1] + (915 * upScale), truckCen[2] + (509 * upScale));
	playAnim('fbiTruck', 'idle', true);
	addLuaSprite('fbiTruck', true);
	setObjAlpha('fbiTruck', 0.00001);
end

truckSnd = '';
soundFading = false;
function onUpdatePost()
	if not soundFading and getObjX('fbiTruck') > (1400 * upScale) then
		soundFading = true;
		
		soundFadeOut(truckSnd, (50 / 60) / playbackRate);
	end
end

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['agentsComeIn'] = function()
		truckSnd = doSound('intro/car loop mega extended');
		
		setObjAlpha('fbiTruck', 1);
		playAnim('fbiTruck', 'drive', true);
		setObjX('fbiTruck', -1000 * upScale);
		
		doTweenX('truckDriveIn', 'fbiTruck', 1000 * upScale, 1.2 / playbackRate, 'QuadOut');
	end,
	['truckGoCS'] = function()
		playAnim('fbiTruck', 'driveAlien', true);
		doTweenX('truckDriveOut', 'fbiTruck', 2500 * upScale, 1.2 / playbackRate, 'QuadIn');
		runTimer('truckShipSmoke', 0.1, 0);
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['truckDriveIn'] = function()
		playAnim('fbiTruck', 'idle', true);
	end,
	['truckDriveOut'] = function()
		cancelTimer('truckShipSmoke');
		removeLuaSprite('fbiTruck');
		removeLuaSprite('smokeTruckLayer');
	end
}

function shipOnTruck()
	playAnim('fbiTruck', 'shipTruck', true);
	
	onChangeFrame('fbiTruck', function(f)
		if f >= 6 then
			doSound('intro/ship hit car');
			
			return true;
		end
		return false;
	end);
end

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
