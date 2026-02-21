upScale = 1 / 0.7;
agents = {
	[1] = {}, -- walk
	[2] = {}, -- stand
	[3] = {}, -- rope
	[4] = {} -- runover
}
earlySpawns = {
	shoot = {},
	stab = {},
	runover = {}
}
agentSpawnDistance = 2700;
function onCreate()
	luaDebugMode = true;
	
	for i, spr in pairs({'shot', 'slashed', 'runover', 'explode', 'bit'}) do
		local t = spr .. 'Cache';
		makeAnimatedLuaSprite(t, 'agent/agents/death/' .. spr, 200, 200);
		addLuaSprite(t, true);
		setObjAlpha(t, 0.00001);
	end
	
	makeAnimatedLuaSprite('agentCache', 'agent/agents/agent', 200, 200);
	addLuaSprite('agentCache', true);
	setObjAlpha('agentCache', 0.00001);
	
	makeAnimatedLuaSprite('agentRunAlienCache', 'agent/agents/walk/alien', 200, 200);
	addLuaSprite('agentRunAlienCache', true);
	setObjAlpha('agentRunAlienCache', 0.00001);
	
	makeAnimatedLuaSprite('ropeLayer', 'agent/agents/fx/rope', 200, 200);
	setObjectOrder('ropeLayer', getObjectOrder('dadGroup') - 1);
	setObjAlpha('ropeLayer', 0.00001);
	
	makeLuaSprite('ropeAgentCache', 'agent/agents/agentRope', 200, 200);
	addLuaSprite('ropeAgentCache', true);
	setObjAlpha('ropeAgentCache', 0.00001);
	
	runHaxeCode([[
		import psychlua.LuaUtils;
		import flixel.group.FlxTypedGroup;
		
		var grpStanders:FlxTypedGroup<FlxBasic>;
		grpStanders = new FlxTypedGroup();
		
		game.addBehindDad(grpStanders);
		setVar('standGrp', grpStanders);
		
		var grpAgents:FlxTypedGroup<FlxBasic>;
		grpAgents = new FlxTypedGroup();
		game.addBehindDad(grpAgents);
		setVar('agentGrp', grpAgents);
		
		createCallback('addAgent', function(t, ty) {
			var grp = ((ty == 'stand') ? grpStanders : grpAgents);
			grp.add(getVar(t));
		});
		
		createCallback('agentPlayAnim', function(o, a, ?f) {
			var grp = getVar(o);
			var firstObj;
			var gotFirst = false;
			var animExisted = false;
			
			for (obj in grp) {
				if (!gotFirst) {
					gotFirst = true;
					firstObj = obj;
				}
				
				var animExists = obj.animation.getByName(a) != null; 
				
				if (animExists) {
					animExisted = true;
					obj.alpha = 1;
					obj.playAnim(a + (f ? '' : 'F'), true);
					
					break;
				} else {
					obj.alpha = 0;
				}
			}
			
			if (!animExisted) firstObj.alpha = 1;
		});
		
		createCallback('removeModchartSpr', function(o) {
			game.modchartSprites.remove(o);
		});
		
		createCallback('agentFinDestroy', function(v, v2) { // v: main group, v2: sprite group
			for (objM in getVar(v2)) {
				if (objM.alpha > 0.00001) { // gets the object with the anim thats currently playing
					objM.animation.finishCallback = function() { // when finished, do thing
						getVar(v).remove(LuaUtils.getObjectDirectly(v2, false));
						var grp = getVar(v2);
						for (obj in grp) {
							grp.remove(obj);
							obj.kill();
							LuaUtils.getTargetInstance().remove(obj, true);
							obj.destroy();
						}
						
						grp.kill();
						LuaUtils.getTargetInstance().remove(grp, true);
					}
					break;
				}
			}
		});
		
		var thisLua = parentLua;
		createGlobalCallback('makeAgent', function(?x, ?y, ?r, ?w) {
			return thisLua.call('spawnAgent', [x, y, r, w]);
		});
		
		createGlobalCallback('alienTryGrabAgent', function(x, s) {
			return thisLua.call('grabAgentFunc', [x, s]);
		});
		
		createCallback('curObjFrameChange', function(o) {
			for (anim in getVar(o)) {
				if (anim.alpha > 0.00001) {
					anim.animation.callback = function(n, f) {
						parentLua.call('grpChangeframe', [o, f]);
					}
					break;
				}
			}
		});
	]]);
end

function onCreatePost()
	table.sort(earlySpawns.shoot);
	table.sort(earlySpawns.stab);
	table.sort(earlySpawns.runover);
	
	setObjectOrder('ropeLayer', getObjectOrder('standGrp') + 1);
	setObjectOrder('agentGrp', getObjectOrder('bfOtherSide') - 1);
	
	for i = 1, 3 do precacheSound('CAR HIT ' .. i); end
	precacheSound('DEATH AGENT');
	precacheSound('FIRE DEATH2');
	
	precacheSound('GRAB SFX');
	precacheSound('BITE READY UP');
	precacheSound('BITE SFX');
end

function destroyCache()
	removeLuaSprite('agentCache');
	removeLuaSprite('agentRunAlienCache');
	removeLuaSprite('ropeAgentCache');
	for i, spr in pairs({'agentRunAlien', 'ropeAgent', 'agent', 'shot', 'slashed', 'runover', 'explode', 'bit'}) do
		removeLuaSprite(spr .. 'Cache');
	end
end

ropeScale = 1.03802281 * upScale;
guardDownScale = 1.03553299 * upScale;
totClimb = 0;
function spawnRopeAgent(x, st)
	totClimb = totClimb + 1;
	x = x or (dadXProper() + (600 * upScale));
	local tRope = 'ropeAGENT' .. totClimb;
	makeAnimatedLuaSprite(tRope, 'agent/agents/fx/rope', x, -342 * upScale);
	addAnimationByPrefix(tRope, 'rope', 'Rope', 28, false);
	addAnimationByIndices(tRope, 'ropeBack', 'Rope', '11,10,9,8,7,6,5,4,3,2,1');
	scaleObject(tRope, ropeScale, ropeScale);
	local cen = getObjCen(tRope);
	addOffset(tRope, 'rope', cen[1] + (108 * upScale), cen[2]);
	setObjFrameRate(tRope, 'rope', 28.8);
	setObjFrameRate(tRope, 'ropeBack', 28.8);
	playAnim(tRope, 'rope', true);
	setObjectOrder(tRope, getObjectOrder('ropeLayer'));
	setObjAlpha(tRope, 0.00001);
	
	local t = 'guardGoingDOWN' .. totClimb;
	makeLuaSprite(t, 'agent/agents/agentRope', x, -682 * upScale);
	scaleObject(t, guardDownScale, guardDownScale);
	addToOffsets(t, 278 * upScale, upScale);
	setObjectOrder(t, getObjectOrder('standGrp') - 1);
	setObjAlpha(t, 0.00001);
	
	addTimer(0.03 / playbackRate, function()
		if luaSpriteExists(tRope) then setObjAlpha(tRope, 1); end
	end);
	
	addTimer(0.42 / playbackRate, function()
		if luaSpriteExists(t) then
			setObjAlpha(t, 1);
		
			doTweenY('guardGOESDOWN' .. totClimb, t, 60 * upScale, 0.6 / playbackRate, 'quadOut');
		end
	end);

	
	table.insert(agents[3], {
		deathTime = (st or 999999),
		tr = tRope,
		tAgent = t,
		cur = totClimb
	});
end

totAgents = 0;
agentScale = 1.03829787 * upScale;
typeToNum = {
	['walk'] = 1,
	['runover'] = 4,
	['stand'] = 2,
}
function spawnAgent(x, y, r, ty, s, d) -- x position, y position, faces right, the type of agent
	totAgents = totAgents + 1;
	ty = ty or 'walk';
	x = x or (dadXProper() + ((d or agentSpawnDistance) * upScale));
	y = y or (591 * upScale);
	local t = 'fbiAgent' .. totAgents;
	local tGrp = 'agentGroup' .. totAgents;
	local w = agentTypeInfo[ty].walk;
	
	makeAnimatedLuaSprite(t, 'agent/agents/agent');
	addAnimationByPrefix(t, 'idle', 'AgentIdle', 15, false);
	addAnimationByPrefix(t, 'walk', 'AgentWalk', 15);
	addAnimationByPrefix(t, 'idleF', 'AgentIdle', 15, false);
	addAnimationByPrefix(t, 'walkF', 'AgentWalk', 15);
	scaleObject(t, agentScale, agentScale);
	local cen = getObjCen(t);
	local yOffIdle = cen[2] + (395 * upScale); local yOffWalk = cen[2] + (397 * upScale);
	addOffset(t, 'idle', cen[1] + (210 * upScale), yOffIdle); addOffset(t, 'idleF', cen[1] + (211 * upScale), yOffIdle);
	addOffset(t, 'walk', cen[1] + (244 * upScale), yOffWalk); addOffset(t, 'walkF', cen[1] + (244 * upScale), yOffWalk);
	setObjFlipXAnim(t, 'idleF', true); setObjFlipXAnim(t, 'walkF', true);
	playAnim(t, (w and (r and 'walk' or 'walkF') or (r and 'idle' or 'idleF')), true);
	
	makeSpriteGrp(tGrp, x, y);
	addToGrp(t, tGrp);
	removeModchartSpr(t);
	addAgent(tGrp, ty);
	if w then setObjVelX(tGrp, 289 * upScale * (r and 2.5 or -2.5) * playbackRate); end
	
	local agentTp = agentTypeInfo[ty];
	
	local extraTagsToAdd = {};
	if agentTp.makeExtra then extraTagsToAdd = agentTp.makeExtra(); end
	
	if #extraTagsToAdd > 0 then
		for i = 1, #extraTagsToAdd do
			addToGrp(extraTagsToAdd[i], tGrp);
			removeModchartSpr(extraTagsToAdd[i]);
		end
	end
	
	table.insert(agents[typeToNum[ty]], {
		tp = ty,
		grp = tGrp,
		ind = totAgents,
		dead = false,
		right = r,
		canIdle = agentTp.idle,
		deathType = agentTp.deathType,
		deathTime = (s or 999999),
	});
	
	return t;
end

agentTypeInfo = {
	['walk'] = {
		idle = false,
		walk = true,
		deathType = '',
	},
	['runover'] = {
		idle = false,
		walk = true,
		deathType = 'runover',
	},
	['stand'] = {
		idle = true,
		walk = false,
		deathType = 'bit',
		makeExtra = function()
			local t = 'fbiAgentRunWITHALIEN' .. totAgents;
		
			makeAnimatedLuaSprite(t, 'agent/agents/walk/alien');
			addAnimationByPrefix(t, 'runWithAlien', 'AgentRunAlien', 15);
			addAnimationByPrefix(t, 'runWithAlienF', 'AgentRunAlien', 15);
			scaleObject(t, upScale, upScale);
			local cen = getObjCen(t);
			local yOff = cen[2] + (567 * upScale);
			addOffset(t, 'runWithAlien', cen[1] + (349 * upScale), yOff);
			addOffset(t, 'runWithAlienF', cen[1] + (224 * upScale), yOff);
			setObjFlipXAnim(t, 'runWithAlienF', true);
			playAnim(t, 'runWithAlienF', true);
			setObjAlpha(t, 0.00001);
			
			local tD = 'fbiAgentDieWITHALIEN' .. totAgents;
		
			makeAnimatedLuaSprite(tD, 'agent/agents/death/bit');
			addAnimationByPrefix(tD, 'prepBite', 'AgentPrepBiteAlien', 15, false);
			addAnimationByPrefix(tD, 'prepBiteF', 'AgentPrepBiteAlien', 15, false);
			addAnimationByPrefix(tD, 'death', 'AgentBitAlien', 11, false);
			addAnimationByPrefix(tD, 'deathF', 'AgentBitAlien', 11, false);
			scaleObject(tD, upScale, upScale);
			local cen = getObjCen(tD);
			local off = {{cen[1] + (710 * upScale), cen[1] + (354 * upScale)}, cen[2] + (624 * upScale)};
			addOffset(tD, 'prepBite', off[1][1], off[2]); addOffset(tD, 'prepBiteF', off[1][2], off[2]);
			addOffset(tD, 'death', off[1][1], off[2]); addOffset(tD, 'deathF', off[1][2], off[2]);
			setObjFlipXAnim(tD, 'prepBiteF', true); setObjFlipXAnim(tD, 'deathF', true);
			setObjFrameRate(tD, 'death', 11.4); setObjFrameRate(tD, 'deathF', 11.4);
			playAnim(tD, 'death', true);
			setObjAlpha(tD, 0.00001);
			
			return {t, tD};
		end
	}
}

function killAgent(a, ty)
	a.dead = true;
	
	local death = makeAgentDeathSpr(ty);
	setObjVelX(a.grp, 0);
	addToGrp(death, a.grp);
	removeModchartSpr(death);
	
	agentPlayAnim(a.grp, 'death', a.right);
	agentFinDestroy('agentGrp', a.grp);
	
	agentDeathNoise(a.tp);
end

totDeath = 0;
function makeAgentDeathSpr(ty)
	totDeath = totDeath + 1;
	local tag = '';
	if deathTypes[ty] then tag = deathTypes[ty](); end
	return tag;
end

scales = {
	shot = 1.03960396 * upScale,
	stab = 1.039239 * upScale,
	bones = 1.03921568 * upScale,
	runover = 1.03934871 * upScale
}

deathTypes = {
	['shot'] = function()
		local t = 'deathSHOT' .. totDeath;
		makeAnimatedLuaSprite(t, 'agent/agents/death/shot');
		addAnimationByPrefix(t, 'death', 'AgentGettingShotAt', 14, false);
		addAnimationByPrefix(t, 'deathF', 'AgentGettingShotAt', 14, false);
		scaleObject(t, scales.shot, scales.shot);
		local cen = getObjCen(t);
		local off = {{cen[1] + (237 * upScale), cen[1] + (287 * upScale)}, cen[2] + (398 * upScale)};
		addOffset(t, 'death', off[1][1], off[2]);
		addOffset(t, 'deathF', off[1][2], off[2]);
		setObjFlipXAnim(t, 'deathF', true);
		setObjFrameRate(t, 'death', 14.4); setObjFrameRate(t, 'deathF', 14.4);
		playAnim(t, 'death', true);
		
		return t;
	end,
	['stab'] = function()
		local t = 'deathSLASHED' .. totDeath;
		makeAnimatedLuaSprite(t, 'agent/agents/death/slashed');
		addAnimationByPrefix(t, 'death', 'AgentSlashed', 14, false);
		addAnimationByPrefix(t, 'deathF', 'AgentSlashed', 14, false);
		scaleObject(t, scales.stab, scales.stab);
		local cen = getObjCen(t);
		local off = {{cen[1] + (549 * upScale), cen[1] + (324 * upScale)}, cen[2] + (756 * upScale)};
		addOffset(t, 'death', off[1][1], off[2]);
		addOffset(t, 'deathF', off[1][2], off[2]);
		setObjFlipXAnim(t, 'deathF', true);
		setObjFrameRate(t, 'death', 14.4); setObjFrameRate(t, 'deathF', 14.4);
		playAnim(t, 'death', true);
		
		return t;
	end,
	['bones'] = function()
		local t = 'deathBONES' .. totDeath;
		makeAnimatedLuaSprite(t, 'agent/agents/death/explode');
		addAnimationByPrefix(t, 'death', 'explosionBONES!!', 18, false);
		addAnimationByPrefix(t, 'deathF', 'explosionBONES!!', 18, false);
		scaleObject(t, scales.bones, scales.bones);
		local cen = getObjCen(t);
		local off = {{cen[1] + (725 * upScale), cen[1] + (652 * upScale)}, cen[2] + (684 * upScale)};
		addOffset(t, 'death', off[1][1], off[2]);
		addOffset(t, 'deathF', off[1][2], off[2]);
		setObjFlipXAnim(t, 'deathF', true);
		playAnim(t, 'death', true);
		
		return t;
	end,
	['runover'] = function()
		local t = 'deathRUNOVER' .. totDeath;
		makeAnimatedLuaSprite(t, 'agent/agents/death/runover');
		addAnimationByPrefix(t, 'death', 'FBIAgentRUNOVER', 28, false);
		addAnimationByPrefix(t, 'deathF', 'FBIAgentRUNOVER', 28, false);
		scaleObject(t, scales.runover, scales.runover);
		local cen = getObjCen(t);
		local off = {cen[1] + (426 * upScale), cen[2] + (452 * upScale)};
		addOffset(t, 'death', off[1], off[2]);
		addOffset(t, 'deathF', off[1], off[2]);
		setObjFrameRate(t, 'death', 28.8); setObjFrameRate(t, 'deathF', 28.8);
		playAnim(t, 'death', true);
		
		return t;
	end
}

function agentDeathNoise(t)
	local soundTag = '';
	if soundsDeath[t] then soundTag = soundsDeath[t](); end
	setSoundPitch(soundTag, getSoundPitch(soundTag) * ((45000 + getRandomInt(-1000, 1000)) / 44100));
end

soundsDeath = {
	['walk'] = function()
		return doSound((getVar('poweredUp') and 'FIRE DEATH2' or 'DEATH AGENT'), 0.2);
	end,
	['rope'] = function()
		return doSound('DEATH AGENT', 0.2);
	end,
	['runover'] = function()
		return doSound('CAR HIT ' .. getRandomInt(1, 3), 0.3);
	end
}

curTime = 0;
function onUpdatePost()
	if inGameOver then return; end
	
	curTime = getSongPosition();
	while #earlySpawns.shoot > 0 and earlySpawns.shoot[1] <= curTime do
		spawnAgent(nil, nil, nil, nil, earlySpawns.shoot[1] + 1428 + 180);
		table.remove(earlySpawns.shoot, 1);
	end
	
	while #earlySpawns.runover > 0 and earlySpawns.runover[1] <= curTime do
		spawnAgent(nil, nil, nil, 'runover', earlySpawns.runover[1] + 1428, 1900);
		table.remove(earlySpawns.runover, 1);
	end
	
	while #earlySpawns.stab > 0 and earlySpawns.stab[1] <= curTime do
		spawnRopeAgent(nil, earlySpawns.stab[1] + 1045);
		table.remove(earlySpawns.stab, 1);
	end
	
	for b = 1, #agents do
		if #agents[b] > 0 then
			for i = 1, #agents[b] do
				local curAgent = agents[b][i];
				if curAgent then funcForType(b, curAgent, i); end
			end
		end
	end
	
	onBeat = false;
end

function funcForType(t, a, i)
	if agentFuncs[t] then agentFuncs[t](a, i); end
end

agentFuncs = {
	[1] = function(a, i) -- shot
		if not a.dead and a.deathTime <= curTime then
			local p = getVar('poweredUp');
			if p then a.right = getRandomBool(); end
			killAgent(a, (p and 'bones' or (getRandomBool() and 'shot' or 'stab')));
			
			table.remove(agents[1], i);
		end
	end,
	[2] = function(a, i) -- stand
		if onBeat and a.canIdle then
			agentPlayAnim(a.grp, 'idle', a.right);
		end
		
		if not a.dead and a.deathTime <= curTime then
			a.dead = true;
			
			setObjVelX(a.grp, 0);
			agentPlayAnim(a.grp, 'prepBite', a.right);
			doSound('BITE READY UP', 0.5);
			
			addTimer(0.223 / playbackRate, function()
				agentPlayAnim(a.grp, 'death', a.right);
				agentFinDestroy('standGrp', a.grp);
				doSound('BITE SFX', 0.5);
				
				onChangeFrame(a.grp, function(f)
					if f >= 3 then
						setObjAlpha('dadGroup', 1);
						actionForAlien('ACTION_jump');
						
						return true;
					end
					return false;
				end);
				
				table.remove(agents[2], i);
			end);
		end
	end,
	[3] = function(a, i) -- rope
		if not a.dead and a.deathTime <= curTime then
			a.dead = true;
			
			local dyingAgent = makeAgentDeathSpr('stab');
			setObjPos(dyingAgent, getObjX(a.tr), 581 * upScale);
			playAnim(dyingAgent, 'deathF', true);
			setObjectOrder(dyingAgent, getObjectOrder(a.tr));
			removeObjOnFinishAnim(dyingAgent);
			agentDeathNoise('rope');
			
			playAnim(a.tr, 'ropeBack', true);
			removeObjOnFinishAnim(a.tr);
			
			removeLuaSprite(a.tAgent);
			
			table.remove(agents[3], i);
		end
	end,
	[4] = function(a, i) -- runover
		if not a.dead and a.deathTime <= curTime then
			cameraShake('game', 3 / 640, 0.15 / playbackRate);
			killAgent(a, 'runover');
			
			table.remove(agents[4], i);
		end
	end
}

onBeat = false;
function onBeatHit()
	onBeat = (curBeat % 2) == 0;
end

function onEventPushed(n, v1, v2, s)
	if pushedEvents[n] then pushedEvents[n](v1, v2, s); end
end

pushedEvents = {
	['Alien Action'] = function(v1, v2, s)
		if v1:find('ACTION_') then
			local action = v1:gsub('ACTION_', '');
			if actionsPre[action] then actionsPre[action](s); end
		end
	end,
	['Agent Run Over'] = function(_, __, s)
		table.insert(earlySpawns.runover, s - 1428);
	end
}

actionsPre = {
	['shoot'] = function(s)
		table.insert(earlySpawns.shoot, s - 1428);
	end,
	['stab'] = function(s)
		table.insert(earlySpawns.stab, s - 1045);
	end
}

function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Set Agent Distance'] = function(v1)
		agentSpawnDistance = tonumber(v1);
	end
}

function grabAgentFunc(x, s)
	if #agents[2] < 1 then return false; end
	
	for i = 1, #agents[2] do
		local curAgent = agents[2][i];
		local dist = getObjX(curAgent.grp);
		dist = math.abs(dist - x);
		if dist < 200 * upScale then
			doSound('GRAB SFX', 0.5);
			
			curAgent.deathTime = s + 5251;
			curAgent.canIdle = false;
			curAgent.right = false;
			agentPlayAnim(curAgent.grp, 'runWithAlien', curAgent.right);
			setObjVelX(curAgent.grp, 289 * upScale * -2.5 * playbackRate);
			
			addTimer(2.737 / playbackRate, function()
				curAgent.right = true;
				agentPlayAnim(curAgent.grp, 'runWithAlien', curAgent.right);
				setObjVelX(curAgent.grp, 289 * upScale * 2.5 * playbackRate);
			end);
			
			return true;
		end
	end
	return false;
end

function onChangeFrame(grp, f)
	curObjFrameChange(grp);
	funcsForGrp[grp] = f;
end

function grpChangeframe(o, f)
	if funcsForGrp[o] and funcsForGrp[o](f) then
		funcsForGrp[o] = nil;
	end
end

funcsForGrp = {};

timerAgent = {}; -- using this code that Cherif gave me a while back
function addTimer(t, c)
    timerAgent[#timerAgent + 1] = c or function() end;
    runTimer("TIMERAGENTSCRIPT_" .. #timerAgent, t);
end

function onTimerCompleted(t)
	if t:find("TIMERAGENTSCRIPT_") then 
		local i = tonumber((t:gsub("TIMERAGENTSCRIPT_", "")))
		if timerAgent[i] then 
			timerAgent[i](); 
			timerAgent[i] = nil;
		end
	end
end
