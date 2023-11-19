upScale = 1 / 0.7;
uberOrder = {4, 5, 3, 2, 1}
uberPos = {
	{x = -57, y = 689},
	{x = 337, y = 848},
	{x = 1242, y = 770},
	{x = 822, y = 860},
	{x = 638, y = 933}
}
runInKids = {}
uberScale = 0.71342685 * upScale * 1.52;
uberRunScale = 1.21818181 * upScale;
uberOffset = {}
function onCreate()
	luaDebugMode = true;
	
	uberOffset = subScrollPos(1.41);
	
	makeAnimatedLuaSprite('fgRunInCache', 'street/fgUberkids/uberkidsChargeFG');
	setObjectCamera('fgRunInCache', 'hud');
	addLuaSprite('fgRunInCache', true);
	setObjAlpha('fgRunInCache', 0.00001);
	
	for i = 1, #uberPos do
		local isFlipped = (i > 2);
		local t = 'uberFGDie' .. i;
		makeAnimatedLuaSprite(t, 'street/fgUberkids/uberkidsShotFG', (uberPos[i].x * upScale) + uberOffset[1], (uberPos[i].y * upScale) + uberOffset[2]);
		addAnimationByPrefix(t, 'idle', 'front 1 head idle', 0, false);
		addAnimationByPrefix(t, 'death', 'front 1 head die', 22, false);
		scaleObject(t, uberScale, uberScale);
		local uberCen = getObjCen(t);
		addOffset(t, 'idle', uberCen[1] + (math.floor((isFlipped and 355 or 356) * 1.52) * upScale), uberCen[2] + (math.floor(307 * 1.52) * upScale));
		addOffset(t, 'death', uberCen[1] + (math.floor((isFlipped and 355 or 356) * 1.52) * upScale), uberCen[2] + (math.floor(307 * 1.52) * upScale));
		setObjFrameRate(t, 'death', 22.8);
		playAnim(t, 'idle', true);
		setScrollFactor(t, 1.41, 1.41);
		addLuaSprite(t, true);
		if isFlipped then setProperty(t .. '.flipX', true); end
		setObjAlpha(t, 0.00001);
	end
end

eventCheck = {
	['Pico Breakdance Shoot'] = true,
	['Pico Epic Shoot'] = true
}
valEvCheck = {
	['true'] = true,
}

function onEventPushed(n, v1, v2, s)
	if eventCheck[n] and valEvCheck[v1] then
		table.insert(runInKids, {
			strumTime = s - 515, 
			uberTag = ''
		});
	end
end

runInSpawned = {}
function onUpdatePost()
	if not inGameOver then
		local songPos = getSongPosition();
		
		while #runInKids > 0 and songPos >= runInKids[1].strumTime do
			table.insert(runInSpawned, runInKids[1]);
			
			local spawnedRun = runInSpawned[#runInSpawned];
			spawnedRun.uberTag = spawnUberRunning((#runInKids % 2 == 0));
			spawnedRun.strumTime = spawnedRun.strumTime + 515;
			
			table.remove(runInKids, 1);
		end
		
		while #runInSpawned > 0 and songPos >= runInSpawned[1].strumTime do
			local t = runInSpawned[1].uberTag;
			playAnim(t, 'death', true);
			removeObjOnFinishAnim(t);
			
			table.remove(runInSpawned, 1);
		end
	end
end

totalUbers = 0;
function spawnUberRunning(isRight)
	totalUbers = totalUbers + 1;
	local t = 'uberRunFG' .. totalUbers;
	local uberX = (isRight and 735 or -447);
	makeAnimatedLuaSprite(t, 'street/fgUberkids/uberkidsChargeFG', ((uberX + getRandomInt(-25, 25)) * upScale) + uberOffset[1], ((1199 - 50 - 1112) * upScale) + uberOffset[2]);
	addAnimationByPrefix(t, 'run', 'UberKidChargingUp', 10, false); addAnimationByPrefix(t, 'death', 'UberKidDying', 11, false);
	scaleObject(t, uberRunScale, uberRunScale);
	local runInCen = getObjCen(t);
	addOffset(t, 'run', runInCen[1], runInCen[2]); addOffset(t, 'death', runInCen[1], runInCen[2]);
	setObjFrameRate(t, 'run', 10.2); setObjFrameRate(t, 'death', 11.4);
	playAnim(t, 'run', true);
	setScrollFactor(t, 1.41, 1.41);
	setObjectOrder(t, getObjectOrder('fgRunInCache') + 1);
	if isRight then setProperty(t .. '.flipX', true); end
	
	return t;
end

totShot = 0;
function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Set Up Uberfront'] = function()
		for i = 1, #uberPos do
			setObjAlpha('uberFGDie' .. i, 1);
		end
	end,
	['Pico Breakdance Shoot'] = function()
		totShot = totShot + 1;
		if frontShot[totShot] then frontShot[totShot](); end
	end
}

frontShot = {
	[1] = function()
		killFGKid(1);
		killFGKid(2);
	end,
	[2] = function()
		killFGKid(3);
	end,
	[3] = function()
		killFGKid(4);
	end,
	[4] = function()
		killFGKid(5);
	end
}

function killFGKid(i)
	local t = 'uberFGDie' .. i;
	
	playAnim(t, 'death', true);
	removeObjOnFinishAnim(t);
end
