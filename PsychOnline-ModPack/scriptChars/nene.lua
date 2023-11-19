upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	local neneScale = {1.08516483 * upScale, 1.07473309 * upScale};
	makeAnimatedLuaSprite('nene', 'characters/nene', 484 * upScale, 255 * upScale);
	addAnimationByPrefix('nene', 'idle', 'NeneIdle', 22, false);
	addAnimationByPrefix('nene', 'prepStab', 'Nene PrepStab', 18, false);
	addAnimationByPrefix('nene', 'stab', 'Nene Stab', 15, false);
	scaleObject('nene', neneScale[1], neneScale[2]);
	local neneCen = getObjCen('nene');
	addOffset('nene', 'idle', neneCen[1] + (197 * upScale), neneCen[2] + (150 * upScale));
	addOffset('nene', 'prepStab', neneCen[1] + (210 * upScale), neneCen[2] + (206 * upScale));
	addOffset('nene', 'stab', neneCen[1] + (210 * upScale), neneCen[2] + (206 * upScale));
	setObjFrameRate('nene', 'idle', 22.8);
	setObjFrameRate('nene', 'stab', 15.6);
	playAnim('nene', 'idle', true);
	addLuaSprite('nene');
	
	local uberRunScale = 0.89473684 * upScale * 1.05;
	makeAnimatedLuaSprite('uberkidRunNENE', 'characters/uberkid/uberkid-run', 150 * upScale, 576 * upScale);
	addAnimationByPrefix('uberkidRunNENE', 'run', 'UberKidRun', 14);
	scaleObject('uberkidRunNENE', uberRunScale, uberRunScale);
	local runCen = getObjCen('uberkidRunNENE');
	addOffset('uberkidRunNENE', 'run', runCen[1] + (math.floor(110 * 1.05) * upScale), runCen[2] + (math.floor(322 * 1.05) * upScale));
	setObjFrameRate('uberkidRunNENE', 'run', 14.4);
	playAnim('uberkidRunNENE', 'run', true);
	setObjectOrder('uberkidRunNENE', getObjectOrder('gfGroup') + 1);
	setObjectColor('uberkidRunNENE', 0x00cfd4f2);
	setObjAlpha('uberkidRunNENE', 0.00001);
	
	local deadUberScale = 1.05022156 * upScale * 1.05;
	makeAnimatedLuaSprite('uberkidDieNENE', 'street/bgkid/bgKidStabbed', 248 * upScale, 621 * upScale);
	addAnimationByPrefix('uberkidDieNENE', 'death', 'UberKidGettingStabbed', 19, false);
	scaleObject('uberkidDieNENE', deadUberScale, deadUberScale);
	local deadUberCen = getObjCen('uberkidDieNENE');
	addOffset('uberkidDieNENE', 'death', deadUberCen[1] + (math.floor(355 * 1.05) * upScale), deadUberCen[2] + (math.floor(498 * 1.05) * upScale));
	setObjFrameRate('uberkidDieNENE', 'death', 19.2);
	playAnim('uberkidDieNENE', 'death', true);
	setObjectOrder('uberkidDieNENE', getObjectOrder('gfGroup') + 1);
	setObjectColor('uberkidDieNENE', 0x00cfd4f2);
	setObjAlpha('uberkidDieNENE', 0.00001);
	hideObjOnFinishAnim('uberkidDieNENE');
	
	runHaxeCode([[
		game.modchartSprites.get('nene').animation.finishCallback = function(n) {
			parentLua.call('onNeneFinishAnim', [n]);
		}
	]]);
end

function onCreatePost()
	precacheSound('knifewhosh');
	precacheSound('stab');
end

function onNeneFinishAnim(n)
	if finAnimsNene[n] then finAnimsNene[n](); end
end

finAnimsNene = {
	['stab'] = function()
		neneCanDance = true;
		neneDance();
	end
}

function onCountdownTick()
	onBeatHit();
end

function onBeatHit()
	neneDance();
end

neneCanDance = true;
function neneDance()
	if neneCanDance then
		playAnim('nene', 'idle', true);
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
neneRaise = false;
function spawnKid()
	if not kidSpawned then
		kidSpawned = true;
		neneRaise = false;
		
		setObjAlpha('uberkidRunNENE', 1);
		setObjX('uberkidRunNENE', -554 * upScale);
		doTweenX('uberRunNENE', 'uberkidRunNENE', 150 * upScale, (crochet / 250) / playbackRate);
	end
end

function onUpdatePost()
	if kidSpawned and not inGameOver then
		if not neneRaise and getObjX('uberkidRunNENE') > (110 * upScale) then
			neneCanDance = false;
			neneRaise = true;
			
			playAnim('nene', 'prepStab', true);
			doSound('knifewhosh', 0.25);
		end
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
	['uberRunNENE'] = function()
		playAnim('nene', 'stab', true);
		
		doSound('stab', 0.34);
		
		killKid();
	end
}

function killKid()
	kidSpawned = false;
	
	setObjAlpha('uberkidRunNENE', 0.00001);
	
	setObjAlpha('uberkidDieNENE', 1);
	playAnim('uberkidDieNENE', 'death', true);
end