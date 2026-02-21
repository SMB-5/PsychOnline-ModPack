upScale = 1 / 0.7;
scrollOffset = {};
function onCreate()
	luaDebugMode = true;
	
	makeGroup('agentBGLayer');
	addInstance('agentBGLayer');
	
	makeAnimatedLuaSprite('agentBGache', 'anywhereUSA/bg/moving/agent', 200, 200);
	addLuaSprite('agentBGache', true);
	setObjAlpha('agentBGache', 0.00001);
	
	scrollOffset = subScrollPos(0.8);
	
	timeTL, timeTR = getRandomInt(6000, 15000) / 1000, getRandomInt(6000, 15000) / 1000;
end

function destroyCache()
	setObjAlpha('agentBGache', 0);
end

totTimeL, timeTL = 0, 0;
totTimeR, timeTR = 0, 0;
canSpawn = false;
leftOffset = ((640 / 0.7) - 640);
function onUpdatePost(e)
	e = e * playbackRate;
	
	if inGameOver then return; end
	
	checkAddSpawn(e);
	
	if #agentGrp > 0 then
		for i = 1, #agentGrp do
			agentFunc(agentGrp[i], i);
		end
	end
end

function checkAddSpawn(e)
	totTimeL, totTimeR = totTimeL + e, totTimeR + e;
	if totTimeL >= timeTL then
		if canSpawn then spawnAgent(false); end
		totTimeL, timeTL = 0, getRandomInt(6000, 15000) / 1000;
	end
	if totTimeR >= timeTR then
		if canSpawn then spawnAgent(true); end
		totTimeR, timeTR = 0, getRandomInt(6000, 15000) / 1000;
	end
end

function agentFunc(a, i)
	if a then
		local screenPos = getScreenPositionX(a.tag);
		local off = (200 * upScale);
		if ((a.left and (screenPos + leftOffset < -off)) or (not a.left and (screenPos - leftOffset > 1280 + off))) then
			removeFromGrp(a.tag, 'agentBGLayer');
			removeLuaSprite(a.tag);
			table.remove(agentGrp, i);
		end
	end
end

function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Allow Spawn'] = function(v1, v2)
		if v1 == 'all' or v1 == 'agentBG' then canSpawn = (v2 == 'true'); end
	end
}

agentGrp = {}
totAgents = 0;
agentScale = 1.29253731 * upScale;
function spawnAgent(goLeft) -- means he spawns on the right and goes toward the left of the screen
	totAgents = totAgents + 1;
	local t = 'agentBG' .. totAgents;
	local x = ((getCamScroll() * 0.8) - leftOffset) + (goLeft and (1280 / 0.7) + (200 * upScale) or (-200 * upScale));
	makeAnimatedLuaSprite(t, 'anywhereUSA/bg/moving/agent', x, (430 * upScale) + scrollOffset[2]);
	addAnimationByPrefix(t, 'walk', 'FBIguyBACK');
	scaleObject(t, agentScale, agentScale);
	local cen = getObjCen(t);
	addOffset(t, 'walk', cen[1] + (216 * upScale), cen[2] + (352 * upScale));
	setObjFrameRate(t, 'walk', 14.4);
	setProperty(t .. '.flipX', goLeft);
	playAnim(t, 'walk', true);
	setScrollFactor(t, 0.8, 0.8);
	setObjectColor(t, 0x007b7bc0);
	addToGrp(t, 'agentBGLayer');
	setObjVelX(t, 289 * upScale * (2 * (goLeft and -1 or 1)) * playbackRate);
	
	table.insert(agentGrp, {
		tag = t,
		left = goLeft
	});
end
