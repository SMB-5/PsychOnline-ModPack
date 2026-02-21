upScale = 1 / 0.7;
isFucked = false;
scrollOffset = {};
function onCreate()
	makeGroup('agentFGLayer');
	addInstance('agentFGLayer', true);
	
	makeAnimatedLuaSprite('agentFGCache', 'anywhereUSA/fg/moving/agent', 200, 200);
	addLuaSprite('agentFGCache', true);
	setObjAlpha('agentFGCache', 0.00001);
	
	scrollOffset = subScrollPos(1.7);
	timeSpawn = getRandomInt(3000, 13000) / 1000;
	isFucked = getProperty('isFucked');
end

function destroyCache()
	setObjAlpha('agentFGCache', 0);
end

totTime, timeSpawn = 0, 0;
canSpawn = false;
leftOffset = ((640 / 0.7) - 640);
function onUpdatePost(e)
	e = e * playbackRate;
	
	if inGameOver then return; end
	
	if isFucked then
		totTime = totTime + e;
		
		if totTime >= timeSpawn then
			if canSpawn then spawnAgentDuo(); end
			timeSpawn, totTime = (getRandomInt(3000, 13000) / 1000), 0;
		end
	end
	
	if #agentGrp > 0 then
		for i = 1, #agentGrp do
			local curAgent = agentGrp[i];
			if curAgent and (getScreenPositionX(curAgent) - leftOffset > 1280 + (933 * upScale)) then
				removeFromGrp(curAgent, 'agentFGLayer');
				removeLuaSprite(curAgent);
				table.remove(agentGrp, i);
			end
		end
	end
end

function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Allow Spawn'] = function(v1, v2)
		if v1 == 'agentFG' then canSpawn = (v2 == 'true'); end
	end
}

function spawnAgentDuo()
	spawnAgent();
	addTimer(0.96 / playbackRate, function() spawnAgent(); end);
end

totAgents = 0;
agentGrp = {};
agentScale = 1.30241187 * upScale;
function spawnAgent()
	totAgents = totAgents + 1;
	local t = 'agentFG' .. totAgents;	
	local x = ((getCamScroll() * 1.7) - leftOffset) - (200 * upScale);
	makeAnimatedLuaSprite(t, 'anywhereUSA/fg/moving/agent', x, ((656 + Random(55)) * upScale) + scrollOffset[2]);
	addAnimationByPrefix(t, 'walk', 'FIBDudeInfront', 25);
	scaleObject(t, agentScale, agentScale);
	local cen = getObjCen(t);
	addOffset(t, 'walk', cen[1] + (351 * upScale), cen[2] + (229 * upScale));
	setObjFrameRate(t, 'walk', 25.2);
	setScrollFactor(t, 1.7, 1.7);
	playAnim(t, 'walk', true);
	setObjectColor(t, 0x00c9bfe5);
	addToGrp(t, 'agentFGLayer');
	setObjVelX(t, 289 * upScale * 4 * playbackRate);
	
	table.insert(agentGrp, t);
end

timerAgent = {}; -- using this code that Cherif gave me a while back
function addTimer(t, onComplete)
    timerAgent[#timerAgent + 1] = onComplete or function() end;
    runTimer("AGENTTIMER_" .. #timerAgent, t);
end

function onTimerCompleted(t)
	if t:find("AGENTTIMER_") then 
		local i = tonumber((t:gsub("AGENTTIMER_", "")))
		if timerAgent[i] then 
			timerAgent[i](); 
			timerAgent[i] = nil;
		end
	end
end
