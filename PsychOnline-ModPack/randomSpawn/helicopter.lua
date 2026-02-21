upScale = 1 / 0.7;
scrollOffset = {};
function onCreate()
	luaDebugMode = true;
	
	makeGroup('heliBGLayer');
	addInstance('heliBGLayer');
	
	makeAnimatedLuaSprite('heliCache', 'anywhereUSA/bg/moving/helicopter', 200, 200);
	addLuaSprite('heliCache', true);
	setObjAlpha('heliCache', 0.00001);
	
	scrollOffset = subScrollPos(0.8);
	
	timeTL, timeTR = getRandomInt(10000, 20000) / 1000, getRandomInt(10000, 20000) / 1000;
end

function destroyCache()
	setObjAlpha('heliCache', 0);
end

totTimeL, timeTL = 0, 0;
totTimeR, timeTR = 0, 0;
canSpawn = false;
leftOffset = ((640 / 0.7) - 640);
function onUpdatePost(e)
	e = e * playbackRate;
	
	if inGameOver then return; end
	
	checkAddSpawn(e);
	
	if #heliGrp > 0 then
		for i = 0, #heliGrp do
			heliFunc(heliGrp[i], i);
		end
	end
end

function checkAddSpawn(e)
	totTimeL, totTimeR = totTimeL + e, totTimeR + e;
	if totTimeL >= timeTL then
		if canSpawn then spawnHeli(false); end
		totTimeL, timeTL = 0, getRandomInt(10000, 20000) / 1000;
	end
	if totTimeR >= timeTR then
		if canSpawn then spawnHeli(true); end
		totTimeR, timeTR = 0, getRandomInt(10000, 20000) / 1000;
	end
end

function heliFunc(h, i)
	if h then
		local screenPos = getScreenPositionX(h.tag);
		local off = (200 * upScale);
		if ((h.left and (screenPos + leftOffset < -off)) or (not h.left and (screenPos - leftOffset > 1280 + off))) then
			removeFromGrp(h.tag, 'heliBGLayer');
			removeLuaSprite(h.tag);
			table.remove(heliGrp, i);
		end
	end
end

function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Allow Spawn'] = function(v1, v2)
		if v1 == 'all' or v1 == 'helicopter' then canSpawn = (v2 == 'true'); end
	end
}

heliGrp = {}
totHeli = 0;
function spawnHeli(goLeft) -- means it spawns on the right and goes toward the left of the screen
	totHeli = totHeli + 1;
	local t = 'heliBG' .. totHeli;
	local x = ((getCamScroll() * 0.8) - leftOffset) + (goLeft and (1280 / 0.7) + (200 * upScale) or (-200 * upScale));
	makeAnimatedLuaSprite(t, 'anywhereUSA/bg/moving/helicopter', x, (430 * upScale) + scrollOffset[2]);
	addAnimationByPrefix(t, 'heli', 'AgentHelicopter', 30);
	scaleObject(t, upScale, upScale);
	local cen = getObjCen(t);
	addOffset(t, 'heli', cen[1] + (160 * upScale), cen[2] + (538 * upScale));
	setProperty(t .. '.flipX', goLeft);
	playAnim(t, 'heli', true);
	setScrollFactor(t, 0.8, 0.8);
	setObjectColor(t, 0x007b7bc0);
	addToGrp(t, 'heliBGLayer');
	setObjVelX(t, 289 * upScale * (2.5 * (goLeft and -1 or 1)) * playbackRate);
	
	table.insert(heliGrp, {
		tag = t,
		left = goLeft
	});
end
