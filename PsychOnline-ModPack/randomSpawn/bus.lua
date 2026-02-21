upScale = 1 / 0.7;
scrollOffset = {};
function onCreate()
	luaDebugMode = true;
	
	makeGroup('busLayer');
	addInstance('busLayer');
	
	makeAnimatedLuaSprite('busCache', 'anywhereUSA/bg/moving/busFatkid', 200, 200);
	addLuaSprite('busCache', true);
	setObjAlpha('busCache', 0.00001);
	
	scrollOffset = subScrollPos(0.8);
end

function destroyCache()
	setObjAlpha('busCache', 0);
end

leftOffset = ((640 / 0.7) - 640);
function onUpdatePost()
	if inGameOver then return; end
	
	if #busGrp > 0 then
		for i = 1, #busGrp do
			busFunc(busGrp[i], i);
		end
	end
end

function busFunc(b, i)
	if b and (getScreenPositionX(b.t) - leftOffset > 1280 + (400 * upScale)) then
		removeFromGrp(b.t, 'busLayer');
		removeLuaSprite(b.t);
		table.remove(busGrp, i);
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		for i = 1, #busGrp do
			if busGrp[i] then playAnim(busGrp[i].t, 'drive', true); end
		end
	end
end

function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Spawn BG'] = function(v1)
		if v1 == 'bus' then
			spawnBus();
		end
	end
}

totBus = 0;
busGrp = {};
function spawnBus()
	totBus = totBus + 1;
	local t = 'busBG' .. totBus;
	local x = ((getCamScroll() * 0.8) - leftOffset) - (200 * upScale);
	makeAnimatedLuaSprite(t, 'anywhereUSA/bg/moving/busFatkid', x, (430 * upScale) + scrollOffset[2]);
	addAnimationByPrefix(t, 'drive', 'BUSBG', 30);
	scaleObject(t, upScale, upScale);
	local cen = getObjCen(t);
	addOffset(t, 'drive', cen[1] + (216 * upScale), cen[2] + (325 * upScale));
	setLoopPoint(t, 'drive', 5);
	setScrollFactor(t, 0.8, 0.8);
	playAnim(t, 'drive', true);
	setObjectColor(t, 0x00b4b4db);
	addToGrp(t, 'busLayer');
	setObjVelX(t, 289 * upScale * 1.25 * playbackRate);
	
	table.insert(busGrp, {
		id = totBus,
		t = t
	});
end
