upScale = 1 / 0.7;
dir = 'wasteland/battlefieldGuys/';

walkS = 0;
snipeS, snipeT = 0, 0;
evilS = 0;
tankS = 0;
specS = 0;
chuteS, chuteT = 0, 0;

towS, towT = 0, 0;
stS = 0;

subD = 0;
paraCanSpawn = true;

holdTable = {};

totSpawned = 0;
allSpawned = {};

parachuters = {};
totParachutes = 0;

leftScreen = 0;
leftOffset = 0;
totEl = 0;
subVel = 0;
subtractFromDie = false;
doingBeat = false;
orderSpawned = false;

function onCreate()
	luaDebugMode = true;
	
	cacheSprites();
	
	startTimers();
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		createCallback('setObjVelX', function(o:String, v:Float) {
			return LuaUtils.getObjectDirectly(o, false).velocity.x = v;
		});
		
		createCallback('getObjCen', function(o:String) {
			var b = LuaUtils.getObjectDirectly(o, false);
			return [(b.frameWidth - b.width) * 0.5, (b.frameHeight - b.height) * 0.5];
		});
		
		createCallback('getWidth', function(o:String) {
			return LuaUtils.getObjectDirectly(o, false).width;
		});
		
		createCallback('getLeftScreen', function() {
			return (game.camGame.scroll.x - ((640 / 0.7) - 640));
		});
		
		createCallback('getLeftOffset', function() {
			return ((640 / 0.7) - 640);
		});
		
		createCallback('addFinCallback', function(o) {
			var anim = LuaUtils.getObjectDirectly(o, false).animation;
			
			anim.finishCallback = function(n) {
				parentLua.call('battlerFinishAnim', [o, n]);
			}
		});
		
		createCallback('setObjFrameRate', function(o, a, f) {
			return LuaUtils.getObjectDirectly(o, false).animation._animations.get(a).frameRate = f;
		});
		
		createCallback('setLoopPoint', function(o, a, l) {
			return LuaUtils.getObjectDirectly(o, false).animation._animations.get(a).loopPoint = l;
		});
		
		createCallback('getObjXY', function(b:String) {
			var h = game.modchartSprites.get(b);
			return [h.x, h.y];
		});
	]]);
end

function spawnBattler(b)
	if not battlers[b] then return; end
	
	totSpawned = totSpawned + 1;
	
	local createInf = battlers[b]();
	
	local batTag = createInf.t;
	table.insert(allSpawned, {
		type = b,
		tag = batTag,
		vel = createInf.v,
		rand = createInf.r,
		y = getProperty(batTag .. '.y'),
		canIdle = true,
		alive = true,
		killable = createInf.canDie,
		explodes = (getRandomInt(1, 3) - 2) == 1,
		deathTime = getRandomInt(310, 600),
		dies = (-Random(100) - 1 + getProperty('killChance')) > 0,
		despawnOff = (createInf.despawnPoint or -200),
		dead = false,
		onBeat = (createInf.idles and function() playAnim(batTag, 'idle', true); end or nil)
	});
	
	addFinCallback(batTag);
	
	orderSpawned = true;
end

function spawnExplosionAt(xPos, yPos) -- DO YOU WANT TO EXPLODE?
	totSpawned = totSpawned + 1;
	
	local t = 'explosionBG' .. totSpawned;
	makeAnimatedLuaSprite(t, dir .. 'MINE', xPos + (99 * upScale), yPos - (77 * upScale));
	addAnimationByPrefix(t, 'explosion', 'MINEXPLO', 29, false);
	setObjFrameRate(t, 'explosion', 28.8);
	scaleObject(t, upScale, upScale);
	local cen = getObjCen(t);
	addOffset(t, 'explosion', cen[1] + (165 * upScale), cen[2] + (121 * upScale));
	playAnim(t, 'explosion', true);
	setScrollFactor(t, 0.4, 0.4);
	
	table.insert(allSpawned, {
		type = 'explosion',
		tag = t,
		vel = 0,
		rand = false,
		y = yPos + (99 * upScale),
		canIdle = false,
		alive = true,
		killable = false,
		explodes = false,
		deathTime = 999999,
		dies = false,
		despawnOff = -10000,
		dead = false
	});
	
	local selected = allSpawned[#allSpawned];
	
	holdTable[t] = {
		grabbedFrom = selected
	}

	addFinCallback(t);
	
	table.sort(allSpawned, function(a, b) return a.y < b.y; end);
end

function spawnParachuters()
	totParachutes = totParachutes + 1;
	
	local t = 'parachuterGOOD' .. totParachutes;
	local tEv = '';
	local spawnKill = (-Random(100) - 1 + getProperty('killChance')) > 0;
	local xPos = (leftScreen * 0.4) + ((getRandomInt(400, 600) + 1400 - Random(1000)) * upScale);
	
	makeAnimatedLuaSprite(t, dir .. 'PARACHUTER', xPos, (-152 - 210) * upScale);
	addAnimationByPrefix(t, 'idle', 'ParashootBattlefield');
	addAnimationByPrefix(t, 'death', 'ParashootDEATHBattlefield', 29, false);
	setObjFrameRate(t, 'death', 28.8);
	scaleObject(t, upScale, upScale);
	local cen = getObjCen(t);
	addOffset(t, 'idle', cen[1] + (90 * upScale), cen[2] + (81 * upScale));
	addOffset(t, 'death', cen[1] + (90 * upScale), cen[2] + (81 * upScale));
	playAnim(t, 'idle', true);
	setScrollFactor(t, 0.4, 0.4);
	setProperty(t .. '.velocity.y', upScale * 60);
	addLuaSprite(t, true);
	
	if spawnKill then
		totParachutes = totParachutes + 1;
		tEv = 'parachuterEVIL' .. totParachutes;
		
		makeAnimatedLuaSprite(tEv, dir .. 'PARACHUTERSHOOT', xPos + (getRandomInt(250, 500) * upScale), (-160 - 210 + getRandomInt(-70, 15)) * upScale);
		addAnimationByPrefix(tEv, 'idle', 'ParashootBattlefieldEVILGUY0');
		addAnimationByPrefix(tEv, 'shoot', 'ParashootBattlefieldEVILGUYSHOOT', 24, false);
		scaleObject(tEv, upScale, upScale);
		local cen = getObjCen(tEv);
		addOffset(tEv, 'idle', cen[1] + (96 * upScale), cen[2] + (81 * upScale));
		addOffset(tEv, 'shoot', cen[1] + (96 * upScale), cen[2] + (81 * upScale));
		playAnim(tEv, 'idle', true);
		setScrollFactor(tEv, 0.4, 0.4);
		setProperty(tEv .. '.velocity.y', upScale * 60);
		addLuaSprite(tEv, true);
	end
	
	table.insert(parachuters, {
		tag = t,
		killTag = tEv,
		dies = spawnKill,
		deathTime = getRandomInt(310, 600),
		dead = false;
	});
	
	orderSpawned = true;
end

battlers = {
	['special'] = function()
			local t = 'specialBG' .. totSpawned;
			local roll = getRandomBool(50); -- if the roll is won then spawn the peeing guy, else spawn the sniper
			
			local spr = (roll and 'PEEING' or 'SNIPER');
			local y = (roll and 400 or 650);
			local idleXML = (roll and 'Peeing' or 'SniperBATTLEFIELD');
			local fps = (roll and 28.8 or 14.4);
			local off = {(roll and 36 or 102), (roll and 45 or 61)};
			
			makeAnimatedLuaSprite(t, dir .. spr, (leftScreen * 0.4) + (1300 * upScale), (y - 210) * upScale);
			addAnimationByPrefix(t, 'idle', idleXML, fps, roll);
			setObjFrameRate(t, 'idle', fps);
			if roll then setLoopPoint(t, 'idle', 9); end
			scaleObject(t, upScale, upScale);
			local cen = getObjCen(t);
			addOffset(t, 'idle', cen[1] + (off[1] * upScale), cen[2] + (off[2] * upScale));
			playAnim(t, 'idle', true);
			setScrollFactor(t, 0.4, 0.4);
			
			return {t = t, v = 0, r = roll, canDie = false, canIdle = true, idles = true};
	end,
	['sniperTower'] = function()
			local t = 'sniperTowerBG' .. totSpawned;
			
			makeAnimatedLuaSprite(t, dir .. 'SNIPERTOWER', (leftScreen * 0.4) + ((1350 + Random(700)) * upScale), (224 - 210) * upScale);
			addAnimationByPrefix(t, 'idle', 'TowerBattlefield', 15, false);
			addAnimationByPrefix(t, 'shoot', 'TowerSHOOTINGBattlefield', 20, false);
			setObjFrameRate(t, 'shoot', 28.8);
			scaleObject(t, upScale, upScale);
			local cen = getObjCen(t);
			addOffset(t, 'idle', cen[1] + (163 * upScale), cen[2] + (282 * upScale));
			addOffset(t, 'shoot', cen[1] + (163 * upScale), cen[2] + (282 * upScale));
			playAnim(t, 'idle', true);
			setScrollFactor(t, 0.4, 0.4);
			
			return {t = t, v = 0, r = false, canDie = false, canIdle = true, idles = true};
	end,
	['tank'] = function()
			local t = 'tankAllyBG' .. totSpawned;
			local roll = ((getRandomInt(1, 3) - 2) == 1);
			local vl = (roll and 6.7 or 6);
			
			makeAnimatedLuaSprite(t, dir .. 'TANK', (leftScreen * 0.4) - (300 * upScale), ((roll and 551 or 401) - 210 + getRandomInt(-15, 5)) * upScale);
			addAnimationByPrefix(t, 'drive', 'tankbattlefieldGO', 18);
			scaleObject(t, upScale, upScale);
			local cen = getObjCen(t);
			addOffset(t, 'drive', cen[1] + (159 * upScale), cen[2] + (99 * upScale));
			playAnim(t, 'drive', true);
			setScrollFactor(t, 0.4, 0.4);
			
			return {t = t, v = vl, r = roll, canDie = false};
	end,
	['runner'] = function()
			local t = 'runnerAllyBG' .. totSpawned;
			local roll = getRandomBool(50);
			
			makeAnimatedLuaSprite(t, dir .. 'RUNNERS', (leftScreen * 0.4) + (1300 * upScale), (450 - 210 + getRandomInt(5, 80)) * upScale);
			addAnimationByPrefix(t, 'walk', (roll and 'TANKCAPSTEVEFIELDRUN' or 'TANKCAPBATTLEFIELDRUN'), 11);
			addAnimationByPrefix(t, 'death', (roll and 'TANKCAPSTEVEDEATHFIELDRUN' or 'TANKCAPDEATHBATTLEFIELDRUN'), 29, false);
			setObjFrameRate(t, 'walk', 11.4);
			setObjFrameRate(t, 'death', 28.8);
			scaleObject(t, upScale, upScale);
			local cen = getObjCen(t);
			addOffset(t, 'walk', cen[1] + ((roll and 120 or 126) * upScale), cen[2] + ((roll and 100 or 58) * upScale));
			addOffset(t, 'death', cen[1] + ((roll and 120 or 126) * upScale), cen[2] + ((roll and 100 or 58) * upScale));
			playAnim(t, 'walk', true);
			setScrollFactor(t, 0.4, 0.4);
			
			return {t = t, v = 2.5, r = roll, canDie = true};
	end,
	['shooter'] = function()
			local t = 'shooterEnemyBG' .. totSpawned;
			
			makeAnimatedLuaSprite(t, dir .. 'SHOOTER', (leftScreen * 0.4) + (1300 * upScale), (450 - 210 + getRandomInt(40, 100)) * upScale);
			addAnimationByPrefix(t, 'idle', 'TankguyEvilBATTLEFIELD', 15, false);
			addAnimationByPrefix(t, 'shoot', 'TankguyEvilSHOOTBATTLEFIELD', 29, false);
			setObjFrameRate(t, 'shoot', 28.8);
			scaleObject(t, upScale, upScale);
			local cen = getObjCen(t);
			addOffset(t, 'idle', cen[1] + (106 * upScale), cen[2] + (61 * upScale));
			addOffset(t, 'shoot', cen[1] + (106 * upScale), cen[2] + (61 * upScale));
			playAnim(t, 'idle', true);
			setScrollFactor(t, 0.4, 0.4);
			
			return {t = t, v = 0, r = false, canDie = false, canIdle = true, idles = true, despawnPoint = -80}; -- making it -80 instead of -50 so it looks less jarring
	end
}

function battlerFinishAnim(t, n)
	if holdTable[t] then
		local i = holdTable[t].grabbedFrom;
		if i.type == 'explosion' then
			removeLuaSprite(i.tag);
			
			local ind = getTblIndTag(i.tag);
			table.remove(allSpawned, ind);
		elseif not i.canIdle and i.alive then
			playAnim(t, 'idle', true);
			
			i.canIdle = true;
		end
		holdTable[t] = nil;
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		doingBeat = true;
	end
end

function onUpdatePost(e)
	e = e * playbackRate;
	totEl = totEl + (e * 1000);
	
	if not inGameOver then
		subtractFromDie = false;
		
		subVel = getProperty('bgSpeed') * -5;
		
		leftOffset = ((640 / 0.7) - 640); --getLeftOffset();
		
		leftScreen = getLeftScreen();
		
		defCamZoom = getProperty('defaultCamZoom');
		
		checkObjTimes(e);
		
		if orderSpawned then table.sort(allSpawned, function(a, b) return a.y < b.y; end); end
		
		updateSpawned();
		updateParachuters();
		
		doingBeat = false;
		orderSpawned = false;
	end
end

function updateSpawned()
	if #allSpawned > 0 then
		for i = 1, #allSpawned do
			if allSpawned[i] then
				local curSel = allSpawned[i]; 
				local netVel = ((curSel.dead and 0 or (curSel.vel * upScale * 60)) + subVel); -- the total velocity that the object is moving at
				
				local contVal = checkOffScreen(curSel, netVel, i);
				
				local spawnedPlosion = false;
				
				if contVal then
					if doingBeat and curSel.onBeat and curSel.canIdle then curSel.onBeat(); end
					
					if curSel.killable and curSel.dies then
						if subtractFromDie then curSel.deathTime = curSel.deathTime - 25; end
						
						if curSel.deathTime <= 0 then
							if curSel.explodes then
								local soldierPos = getObjXY(curSel.tag);
								spawnExplosionAt(soldierPos[1], soldierPos[2]);
								spawnedPlosion = true;
							else
								if curSel.deathTime == 0 then
									local allOfShooter = typeFromGroup('shooter');
									local selected;
									for i = 1, #allOfShooter do
										local curShooter = allSpawned[allOfShooter[i]];
										local daX = getScreenPositionX(curShooter.tag) - leftOffset;
										
										if daX > (600 + Random(50) * upScale) and daX < (1000 * upScale) then
											selected = curShooter;
										end
									end
									if selected then
										holdTable[selected.tag] = {
											grabbedFrom = selected;
										}
											
										selected.canIdle = false;
										playAnim(selected.tag, 'shoot', true);
									end
								end
							end
							playAnim(curSel.tag, 'death', true);
							
							netVel = subVel;
							curSel.killable = false;
							curSel.dead = true;
						end
					end
					if orderSpawned then
						local t = curSel.type;
						setObjectOrder(curSel.tag, getObjectOrder('SNIPERTOWERCache') + (t == 'sniperTower' and 0 or (t == 'special' and curSel.rand) and -1 or i));
					end
					setObjVelX(curSel.tag, netVel);
				end
			end
		end
	end
end

function updateParachuters()
	if #parachuters > 0 then
		for i = 1, #parachuters do
			local curSel = parachuters[i];
			if curSel then
				local isKilled = curSel.dies;
				
				local mostRight = (isKilled and curSel.killTag or curSel.tag);
				local cont = true;
				
				if getScreenPositionX(mostRight) + leftOffset < (-300 * upScale) then
					removeLuaSprite(curSel.tag);
					if isKilled then removeLuaSprite(curSel.killTag); end
					
					table.remove(parachuters, i);
					
					cont = false;
				end
				
				if cont then
					local sinVel = (math.sin((totEl / 20) * math.pi / 180));
					local netVel = ((sinVel * upScale * 60) + subVel);
					
					setObjVelX(curSel.tag, netVel);
					
					if isKilled then
						local newSinVel = (math.sin(((totEl + 1400) / 13) * math.pi / 180));
						local newNetVel = ((newSinVel * upScale * 60) + subVel);
						
						setObjVelX(curSel.killTag, newNetVel);
						
						if not curSel.dead then
							if subtractFromDie then curSel.deathTime = curSel.deathTime - 25; end
							
							if curSel.deathTime <= 0 then
								playAnim(curSel.tag, 'death', true);
								playAnim(curSel.killTag, 'shoot', true);
								
								curSel.dead = true;
							end
						end
					end
					if orderSpawned then
						setObjectOrder(curSel.tag, getObjectOrder('SNIPERTOWERCache') + #allSpawned + i);
						
						if curSel.dies then
							setObjectOrder(curSel.killTag, getObjectOrder('SNIPERTOWERCache') + #allSpawned + i);
						end
					end
				end
			end
		end
	end
end

function checkObjTimes(e)
	local spawnRate = getProperty('spawnRateBG');
	
	walkS = walkS + e; -- the runner's spawn time
	snipeS = snipeS + e; -- the sniper tower's spawn time
	evilS = evilS + e; -- the shooter's spawn time
	tankS = tankS + e; -- the tank's spawn time
	specS = specS + e; -- the special's spawn time
	chuteS = chuteS + e; -- the parachuter's spawn time

	towS = towS + e; -- elapsed time to make the tower shoot
	stS = stS + e; -- elapsed time to make the shooter's shoot
	
	subD = subD + e; -- elapsed time to make the runner's die
	
	if walkS >= 0.5 then
		walkS = 0;
		if spawnRate > Random(100) then spawnBattler('runner'); end
	end
	
	if snipeS >= snipeT then
		snipeT, snipeS = (getRandomInt(6000, 8000) / 1000), 0;
		if spawnRate > Random(100) then spawnBattler('sniperTower'); end
	end
	
	if evilS >= 1.5 then
		evilS = 0;
		if spawnRate > Random(100) then spawnBattler('shooter'); end
	end
	
	if tankS >= 10 then
		tankS = 0;
		if spawnRate > Random(100) then spawnBattler('tank'); end
	end
	
	if specS >= 5 then
		specS = 0;
		if spawnRate > Random(100) then spawnBattler('special'); end
	end
	
	if chuteS >= chuteT then
		chuteT, chuteS = ((7000 + Random(2000)) / 1000), 0;
		if paraCanSpawn and spawnRate > Random(100) then spawnParachuters(); end
	end
	
	if towS >= towT then
		towT, towS = (getRandomInt(1000, 7000) / 1000), 0;
		if spawnRate > Random(100) then
			local randSniper = pickOneOf('sniperTower');
			local selected = allSpawned[randSniper];
			if selected then
				holdTable[selected.tag] = {
					grabbedFrom = selected;
				}
			
				selected.canIdle = false;
				playAnim(selected.tag, 'shoot', true);
			end
		end
	end
	
	if stS >= 1 then
		stS = 0;
		if spawnRate > Random(100) then
			local randStand = pickOneOf('shooter');
			local selected = allSpawned[randStand]
			if selected then
				holdTable[selected.tag] = {
					grabbedFrom = selected;
				}
				
				selected.canIdle = false;
				playAnim(selected.tag, 'shoot', true);
			end
		end
	end
	
	if subD >= 0.25 then
		subtractFromDie = true;
		subD = 0;
	end
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Set Parachute Spawn'] = function()
		paraCanSpawn = not paraCanSpawn;
	end
}

sprites = {'SHOOTER', 'TANK', 'RUNNERS', 'PEEING', 'SNIPER', 'MINE', 'PARACHUTER', 'PARACHUTERSHOOT', 'SNIPERTOWER'};

function cacheSprites()
	for i = 1, #sprites do
		local spr = sprites[i];
		makeAnimatedLuaSprite(spr .. 'Cache', dir .. spr, -100);
		addLuaSprite(spr .. 'Cache');
		setProperty(spr .. 'Cache.alpha', 0.00001);
	end
end

function startTimers()
	snipeT = (getRandomInt(6000, 8000) / 1000);
	chuteT = ((7000 + (getRandomInt(1, 2000) - 1)) / 1000);
	towT = (getRandomInt(1000, 7000) / 1000);
end

function checkOffScreen(curSel, vel, i)
	if vel < 0 then -- going left
		if getScreenPositionX(curSel.tag) + leftOffset < (curSel.despawnOff * upScale) then
			removeLuaSprite(curSel.tag);
			table.remove(allSpawned, i);

			return false;
		end
	end
	if vel > 0 then -- going right
		if (getScreenPositionX(curSel.tag) - getWidth(curSel.tag)) > ((1280 / defCamZoom) - leftOffset) then
			removeLuaSprite(curSel.tag);
			table.remove(allSpawned, i);

			return false;
		end
	end
	
	return true;
end

function typeFromGroup(tp)
	local allOf = {};
	if #allSpawned > 0 then
		for i = 1, #allSpawned do
			if allSpawned[i] and allSpawned[i].type == tp then
				table.insert(allOf, 1, i);
			end
		end
	end
	return allOf;
end

function pickOneOf(tp)
	if #allSpawned > 0 then
		local allOf = {};
		for i = 1, #allSpawned do
			if allSpawned[i] and allSpawned[i].type == tp then
				table.insert(allOf, 1, i);
			end
		end
		if #allOf > 0 then
			return allOf[getRandomInt(1, #allOf)]
		end
	end
	return -1;
end

function getTblIndTag(t)
	if #allSpawned > 0 then
		for i = 1, #allSpawned do
			if allSpawned[i] and allSpawned[i].tag == t then
				return i;
			end
		end
	end
end

function Random(r) return getRandomInt(0, r - 1); end
