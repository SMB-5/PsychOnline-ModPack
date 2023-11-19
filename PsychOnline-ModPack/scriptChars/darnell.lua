upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	local darnellScale = {1.12179487 * upScale, 1.12420382 * upScale};
	makeAnimatedLuaSprite('darnell', 'characters/darnell', 779 * upScale, 234 * upScale);
	addAnimationByPrefix('darnell', 'idle', 'DarnellIdle', 22, false);
	addAnimationByPrefix('darnell', 'burn', 'DarnellBurn', 28, false);
	scaleObject('darnell', darnellScale[1], darnellScale[2]);
	local darnellCen = getObjCen('darnell');
	addOffset('darnell', 'idle', darnellCen[1] + (175 * upScale), darnellCen[2] + (176 * upScale));
	addOffset('darnell', 'burn', darnellCen[1] + (174 * upScale), darnellCen[2] + (210 * upScale));
	setObjFrameRate('darnell', 'idle', 22.8);
	setObjFrameRate('darnell', 'burn', 28.8);
	playAnim('darnell', 'idle', true);
	addLuaSprite('darnell');
	
	local uberRunScale = 0.89473684 * upScale * 1.05;
	makeAnimatedLuaSprite('uberkidRunDARNELL', 'characters/uberkid/uberkid-run', 1130 * upScale, 577 * upScale);
	addAnimationByPrefix('uberkidRunDARNELL', 'run', 'UberKidRun', 14);
	scaleObject('uberkidRunDARNELL', uberRunScale, uberRunScale);
	local runCen = getObjCen('uberkidRunDARNELL');
	addOffset('uberkidRunDARNELL', 'run', runCen[1] + (math.floor(229 * 1.05) * upScale), runCen[2] + (math.floor(322 * 1.05) * upScale));
	setObjFrameRate('uberkidRunDARNELL', 'run', 14.4);
	playAnim('uberkidRunDARNELL', 'run', true);
	setObjectOrder('uberkidRunDARNELL', getObjectOrder('gfGroup') + 1);
	setObjectColor('uberkidRunDARNELL', 0x00f7ece0);
	setProperty('uberkidRunDARNELL.flipX', true);
	setObjAlpha('uberkidRunDARNELL', 0.00001);
	
	local deadUberScale = 0.94505494 * upScale;
	makeAnimatedLuaSprite('uberkidDieDARNELL', 'street/bgkid/bgKidBurnt', 1110 * upScale, 407 * upScale);
	addAnimationByPrefix('uberkidDieDARNELL', 'death', 'UberKidBurnt', 19, false);
	scaleObject('uberkidDieDARNELL', deadUberScale, deadUberScale);
	local deadUberCen = getObjCen('uberkidDieDARNELL');
	addOffset('uberkidDieDARNELL', 'death', deadUberCen[1] + (215 * upScale), deadUberCen[2] + (180 * upScale));
	setObjFrameRate('uberkidDieDARNELL', 'death', 19.2);
	playAnim('uberkidDieDARNELL', 'death', true);
	setObjectOrder('uberkidDieDARNELL', getObjectOrder('darnell') - 1);
	setObjectColor('uberkidDieDARNELL', 0x00faf8f1);
	setObjAlpha('uberkidDieDARNELL', 0.00001);
	hideObjOnFinishAnim('uberkidDieDARNELL');
	
	runHaxeCode([[
		game.modchartSprites.get('darnell').animation.finishCallback = function(n) {
			parentLua.call('onDarnellFinishAnim', [n]);
		}
	]]);
end

function onCreatePost()
	precacheSound('spraySFX');
end

function onDarnellFinishAnim(n)
	if finAnimsDarnell[n] then finAnimsDarnell[n](); end
end

finAnimsDarnell = {
	['burn'] = function()
		darnellCanDance = true;
		darnellDance();
	end
}

function onCountdownTick()
	onBeatHit();
end

function onBeatHit()
	darnellDance();
end

darnellCanDance = true;
function darnellDance()
	if darnellCanDance then
		playAnim('darnell', 'idle', true);
	end
end

canSpawn = false;
spawnChance = 52;
function onSectionHit()
	canSpawn = not canSpawn;
	if canSpawn and getRandomInt(1, 100) <= spawnChance then
		spawnKid();
	end
end

kidSpawned = false;
function spawnKid()
	if not kidSpawned then
		kidSpawned = true;
		
		setObjAlpha('uberkidRunDARNELL', 1);
		setObjX('uberkidRunDARNELL', 1826 * upScale);
		doTweenX('uberRunDARNELL', 'uberkidRunDARNELL', 1130 * upScale, (crochet / 250) / playbackRate);
	end
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Pico Breakdance'] = function()
		spawnChance = 90;
	end,
	['Epic Part End'] = function()
		spawnChance = 52;
	end,
	['Final Scene'] = function()
		spawnChance = 0;
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['uberRunDARNELL'] = function()
		darnellCanDance = false;
		playAnim('darnell', 'burn', true);
		
		doSound('spraySFX', 0.22);
		
		killKid();
	end
}

function killKid()
	kidSpawned = false;
	
	setObjAlpha('uberkidRunDARNELL', 0.00001);
	
	setObjAlpha('uberkidDieDARNELL', 1);
	playAnim('uberkidDieDARNELL', 'death', true);
end