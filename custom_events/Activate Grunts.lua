upScale = 1 / 0.7;
areActive = false;
climbers = {
	{ -- left cliff
		pos = {
			199 * upScale,
			381 * upScale
		},
		angle = -5,
		shooter = 'san',
		spawnedGrunt = ''
	},
	{ -- right cliff
		pos = {
			1228 * upScale,
			404 * upScale
		},
		angle = 8,
		shooter = 'dei',
		spawnedGrunt = ''
	},
	{ -- speaker
		pos = {
			653 * upScale,
			148 * upScale
		},
		shooter = 'both',
		spawnedGrunt = ''
	}
}
function onCreatePost()
	luaDebugMode = true;
	
	local gruntScale = 0.85323383 * upScale;
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		createCallback('setObjFinAnim', function(o, f) {
			var b = LuaUtils.getObjectDirectly(o, false);
			
			b.animation.finishCallback = function(n) {
				parentLua.call(f, [o, n]);
			}
		});
	]]);
	
	for i = 1, #climbers do
		local t = 'climberBG' .. i;
		makeAnimatedLuaSprite(t, 'nevada/climbers', climbers[i].pos[1], climbers[i].pos[2]);
		addAnimationByPrefix(t, 'climbGRUNT', 'gruntclimb', 21, false); addAnimationByPrefix(t, 'dieGRUNT', 'gruntdie', 21, false);
		addAnimationByPrefix(t, 'climbAGENT', 'agentclimb', 21, false); addAnimationByPrefix(t, 'dieAGENT', 'agentdie', 21, false);
		addAnimationByPrefix(t, 'climbENGI', 'engclimb', 21, false); addAnimationByPrefix(t, 'dieENGI', 'engdie', 21, false);
		scaleObject(t, gruntScale, gruntScale);
		local gruntOff = getObjCen(t);
		offsetAnims(t, {'climbGRUNT', 'dieGRUNT', 'climbAGENT', 'dieAGENT', 'climbENGI', 'dieENGI'}, gruntOff[1] + (171 * upScale), gruntOff[2] + (148 * upScale));
		playAnim(t, 'climbGRUNT', true);
		if climbers[i].angle then setProperty(t .. '.angle', climbers[i].angle); end
		if i == 3 then setObjectOrder(t, getObjectOrder('gfGroup') + 1); else setObjectOrder(t, getObjectOrder('ground') + 1); end
		setObjFinAnim(t, 'gruntFinAnim');
		setObjAlpha(t, 0.00001);
	end
	
	precacheSound('hankshoot');
	precacheSound('death sound');
end

function gruntFinAnim(o, t)
	if t:find('die') then setObjAlpha(o, 0.00001); end
end

function onSectionHit()
	if areActive then
		trySpawnClimbers();
	end
end

function trySpawnClimbers()
	for i = 1, #climbers do
		if i == getRandomInt(1, 3) then
			spawnClimber(i);
		end
	end
end

gruntTypes = {'GRUNT', 'AGENT', 'ENGI'};
function spawnClimber(i)
	local chosenGrunt = getRandomGrunt();
	local t = 'climberBG' .. i;
	
	setObjAlpha(t, 1);
	playAnim(t, 'climb' .. chosenGrunt, true);
	
	addTimer(((crochet / 1000) * 2) / playbackRate, 
		function()
			sanfordDeimosShoot(climbers[i].shooter);
			
			playAnim(t, 'die' .. chosenGrunt, true);
			
			doSound('hankshoot', 0.4, 'GRUNTSHOT');
			doSound('death sound', 0.4, 'GRUNTDIE');
		end);
	
	climbers[i].spawnedGrunt = chosenGrunt;
end

function getRandomGrunt() return gruntTypes[getRandomInt(1, #gruntTypes)]; end

timers = {}; -- using this code that Cherif gave me a while back
function addTimer(time, onComplete)
    timers[#timers + 1] = onComplete or function() end;
    runTimer("TIMERGRUNT_" .. #timers, time);
end

function onTimerCompleted(t)
	if t:find("TIMERGRUNT_") then timers[tonumber((t:gsub("TIMERGRUNT_", "")))](); end
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Activate Grunts'] = function()
		areActive = not areActive;
	end
}

function offsetAnims(o, a, x, y)
	for i = 1, #a do
		addOffset(o, a[i], x, y);
	end
end
