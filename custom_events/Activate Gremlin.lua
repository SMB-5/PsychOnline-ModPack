function onCreate()
	luaDebugMode = true;
	
	local multNum = downscroll and -1 or 1;
	local gremY = (downscroll and 720 - 648 - math.floor(263 * 0.7) or 648);
	makeAnimatedLuaSprite('gremlin', 'mechanics/gremlin', 620, gremY);
	addAnimationByPrefix('gremlin', 'enter', 'gremlinEnter', 30, false);
	addAnimationByPrefix('gremlin', 'pull', 'gremlinPull', 21);
	addAnimationByPrefix('gremlin', 'exit', 'gremlinExit', 30, false);
	scaleObject('gremlin', 0.7, 0.7 * multNum);
	local gremCen = getObjCen('gremlin');
	addOffset('gremlin', 'enter', gremCen[1] + (math.floor(227 * 0.7)), gremCen[2] + (math.floor(263 * 0.7 * multNum)));
	addOffset('gremlin', 'pull', gremCen[1] + (math.floor(227 * 0.7)), gremCen[2] + (math.floor(282 * 0.7 * multNum)));
	addOffset('gremlin', 'exit', gremCen[1] + (math.floor(227 * 0.7)), gremCen[2] + (math.floor(263 * 0.7 * multNum)));
	setLoopPoint('gremlin', 'pull', 14);
	playAnim('gremlin', 'pull', true);
	setObjectCamera('gremlin', 'hud');
	setObjectOrder('gremlin', 0);
	setObjAlpha('gremlin', 0.00001);
	setProperty('gremlin.visible', not hideHud);
	
	runHaxeCode([[
		var grem = game.modchartSprites.get('gremlin');
		
		grem.animation.callback = function(n, f) {
			parentLua.call('gremlinFrameChange', [n, f]);
		}
		
		grem.animation.finishCallback = function(n) {
			parentLua.call('gremlinFinishAnim', [n]);
		}
	]]);
end

function gremlinFrameChange(n, f)
	if frameChanges[n] then frameChanges[n](f); end
end

frameChanges = {
	['pull'] = function(f)
		if gremSpawned and not isDraining and f >= 6 then
			isDraining = true;
		end
	end
}

function gremlinFinishAnim(n)
	if finishAnims[n] then finishAnims[n](); end
end

finishAnims = {
	['enter'] = function()
		activeTime = 800;
		
		playAnim('gremlin', 'pull', true);
	end,
	['exit'] = function()
		setObjAlpha('gremlin', 0.00001);
	end
}

spawnTime = 0;
checkSpawn = false;
gremSpawned = false;
isDraining = false;
luckGremElapsed = 0;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if not inGameOver then
		if checkSpawn then 
			spawnTime = spawnTime - (e / 0.01);
			
			if spawnTime < 0 then
				if botPlay or getAccuracy() > 60 then
					
					checkSpawn = false;
					
					spawnGremlin();
				elseif not botPlay and getAccuracy() <= 60 then
					spawnTime = getRandomInt(0, 350);
				end
			end
		end
		
		if isDraining then
			addTimeToTick(e);
			
			luckGremElapsed = luckGremElapsed + e;
			if luckGremElapsed >= 0.5 then
				luckGremElapsed = 0;
				
				if getRandomInt(1, 3) == 2 then activeTime = activeTime - 200; end
			end
			
			local healthToTake = 0.02 * (e / 0.11);
			addHealth(-healthToTake);
			
			if getHealth() <= 0.12 then
				activeTime = 0;
			end
			
			activeTime = activeTime - (e / 0.01);
			if activeTime <= 0 then
				scareGremlin();
			end
		end
	end
end

function onGremlinTick() -- should trigger every 1 / 60 of a second
	if getHealth() >= 1.6 and getRandomInt(1, 3) == 2 then
		activeTime = activeTime + 20;
	end
end

adjustPos = 0;
function addTimeToTick(e)
	adjustPos = adjustPos + e;
	
	if adjustPos >= (1 / 60) then
		local amountToLoop = math.floor(adjustPos / (1 / 60));
		for i = 1, amountToLoop do
			adjustPos = adjustPos - (1 / 60);
			
			onGremlinTick();
		end
	end
end

function noteMiss()
	if isDraining then
		scareGremlin();
	end
end

function getAccuracy()
	return math.floor(getProperty('ratingPercent') * 10000) / 100;
end

function onEvent(n)
	if events[n] then
		events[n]();
	end
end

events = {
	['Activate Gremlin'] = function()
		spawnTime = getRandomInt(0, 350);
		checkSpawn = true;
	end
}

gremIsActive = false;
isDraining = false;
function spawnGremlin()
	if not gremSpawned then
		gremSpawned = true;
	
		setObjAlpha('gremlin', 1);
		playAnim('gremlin', 'enter', true);
	end
end

function scareGremlin()
	if gremSpawned then
		gremSpawned = false;
		
		isDraining = false;
		
		playAnim('gremlin', 'exit', true);
		
		spawnTime = getRandomInt(200, 500);
		checkSpawn = true;
	end
end
