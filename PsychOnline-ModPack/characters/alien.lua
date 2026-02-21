upScale = 1 / 0.7;
isWalking = false;
dadYPos = 0;
singAnims = {};
canSing = true;
firstWalk = true;
groundFlip = false;
watched = false;
walkShoot = false;
isJumping = false;
function onCreate()
	luaDebugMode = true;

	alienScale = 0.728 * upScale * 1.01;
	scaleObject('dad', alienScale, alienScale);
	resizeOffsets('dad', alienScale);
	
	runHaxeCode([[
		createGlobalCallback('dadXProper', function() {
			return parentLua.call('getFixedDadX', []);
		});
		
		createGlobalCallback('actionForAlien', function(a) {
			parentLua.call('doAction', [a]);
		});
		
		game.dad.animation.finishCallback = function(n) {
			parentLua.call('onAliFinishAnim', [n]);
		}
		
		function callbackExtraObj() {
			game.modchartSprites.get('alienShootWalk').animation.finishCallback = function() {
				parentLua.call('onAliFinishAnim', ['shoot-walk']);
			}
		}
		
		setVar('poweredUp', false);
		setVar('alienDad', game.dad);
	]]);
	
	makeGroup('pelletGrp');
	makeSpriteGrp('flashesGrp');
	
	setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') + 1);
	
	local aliShootScale = 0.72753623 * upScale;
	makeAnimatedLuaSprite('alienShootWalk', 'characters/alien/alien-shootWalk', 200, 200);
	addAnimationByPrefix('alienShootWalk', 'shoot', 'AlienHominidShootsRun', 21, false);
	scaleObject('alienShootWalk', aliShootScale, aliShootScale);
	local aliShootCen = getObjCen('alienShootWalk');
	addOffset('alienShootWalk', 'shoot', aliShootCen[1] + (221 * upScale), aliShootCen[2] + (358 * upScale));
	setObjFrameRate('alienShootWalk', 'shoot', 21.6);
	playAnim('alienShootWalk', 'shoot', true);
	setObjectOrder('alienShootWalk', getObjectOrder('dadGroup'));
	setObjAlpha('alienShootWalk', 0.00001);
	runHaxeFunction('callbackExtraObj');
	
	makeAnimatedLuaSprite('pelletCache', 'fx/shoot/pow', 200, 200);
	setObjAlpha('pelletCache', 0.00001);
	addLuaSprite('pelletCache', true);
	
	makeAnimatedLuaSprite('flashesCache', 'fx/shoot/gunFlash', 200, 200);
	setObjAlpha('flashesCache', 0.00001);
	addLuaSprite('flashesCache', true);
	
	setObjFrameRate('alienDad', 'idle-alt', 14.4);
	setObjFrameRate('alienDad', 'stare', 15.6);
	setObjFrameRate('alienDad', 'shoot', 19.2);
	setObjFrameRate('alienDad', 'stab', 19.8);
	setObjFrameRate('alienDad', 'jump-shoot', 9.6);
	setObjFrameRate('alienDad', 'hey', 28.8);
	setLoopPoint('alienDad', 'stare', 4);
	setLoopPoint('alienDad', 'jump', 1);
	setLoopPoint('alienDad', 'hey', 8);
	
	setVar('isAlienWalking', false);
	
	setProperty('alienDad.idleSuffix', '-alt');
	makeCharDance('alienDad');
	
	dadYPos = getObjY('dadGroup');
end

function onCreatePost()
	singAnims = getProperty('singAnimations');
	
	precacheSound('JUMP SFX');
	
	setObjectOrder('pelletGrp', getObjectOrder('agentGrp') + 1);
	setObjectOrder('flashesGrp', getObjectOrder('pelletGrp') + 1);
	
	calcMove();
end

alienPositions = {};
currentTime = 0;
timeTo = 0;

startingXAlien = 0;
endXAlien = 0;

currentWalkAt = 0;
currentWalkEndAt = 0;
function calcMove()
	local alienStartPos = getObjX('dadGroup');
	local dadOffset = -((math.floor(182 * 1.01) * upScale) - 8.7192) + 130; 
	
	for i = 1, #allWalking do
		local walkWhen = allWalking[i].walksAt;
		local nextIndex = allWalking[i + 1];
		
		local aliStartX = alienStartPos;
		local addXAlien = ((allWalking[i].walkSpd > 0) and (allWalking[i].walkSpd * upScale * (songLoopsFromTime((nextIndex and nextIndex.walksAt or (songLength + 1000)) - walkWhen) + 1)) or 0);
		
		local duringCar = (walkWhen >= getProperty('carStartTime') and walkWhen <= getProperty('carStopTime'));
		if duringCar then
			allWalking[i].walksAt = getProperty('carStopTime');
			walkWhen = getProperty('carStopTime');
			
			aliStartX = getProperty('carStopX') + dadOffset - (15 * upScale);
			local extraDistance = (songLoopsFromTime(nextIndex.walksAt - getProperty('carStopTime'))) * upScale;
			
			addXAlien = aliStartX + extraDistance - alienStartPos;
		end
		if allWalking[i].forcingPos then
			addXAlien = (forcedPos[1] + dadOffset) - alienStartPos;
			table.remove(forcedPos, 1);
		end
		
		table.insert(alienPositions, {
			startX = aliStartX,
			endX = alienStartPos + addXAlien,
			
			startWalkingAt = walkWhen,
			stopsWalkingAt = (nextIndex and nextIndex.walksAt or (songLength + 1000))
		});
		
		alienStartPos = alienStartPos + addXAlien;
	end
	
	table.insert(alienPositions, {
		startX = 0,
		endX = 0,
		
		startWalkingAt = 999999,
		stopsWalkingAt = 999999
	});
	
	currentTime = 0; -- current time to check for
	timeTo = alienPositions[1].startWalkingAt; -- next time to go to
	
	currentWalkAt = 0;
	currentWalkEndAt = 0;
	
	startingXAlien = getObjX('dadGroup');
	endXAlien = getObjX('dadGroup');
end

function onAliFinishAnim(n)
	if alienActionAnimFin[n] then 
		alienActionAnimFin[n]();
	
		onFinishAction();
	end
	
	if alienFinAnim[n] then 
		alienFinAnim[n]();
	end
end

alienFinAnim = {
	['transition'] = function()
		groundAlienDance();
	end
}

alienActionAnimFin = {
	['shoot-walk'] = function()
		setObjAlpha('alienShootWalk', 0);
		walkShoot = false;
	end,
	['stab'] = function()
		stabbing = false;
		
		walkingAnim = isWalking;
	end
}

function onFinishAction()
	isActioning = false;
	canSing = true;
	
	setProperty('alienDad.skipDance', false);
	makeCharDance('alienDad');
end

function getFixedDadX()
	return (getObjX('dadGroup') - 130) + (math.floor(182 * 1.01) * upScale) - 8.7192;
end

function getFixedDadY()
	return (getObjY('dadGroup') + 318) + (math.floor(333 * 1.01) * upScale) - 11.8944;
end

curWalkFrame = 0;
walkingAnim = false;
grounded = true;
jumpY = 0;
updatePos = true;
songPos = 0;
function onUpdatePost(e)
	e = e * playbackRate;
	songPos = getSongPosition();
	
	if inGameOver then return; end
	
	if walkingAnim then
		curWalkFrame = curWalkFrame + (e * 12);
		local alienWalkFrame = math.floor(curWalkFrame % 5);
		
		setCurFrame('alienDad', alienWalkFrame);
	end
	
	if updatePos then
		if songPos >= timeTo then
			alienNextPosition();
		end
		
		if getObjX('dadGroup') ~= endXAlien and not getProperty('inCar') then
			local per = (songPos - currentWalkAt) / (currentWalkEndAt - currentWalkAt);
			setObjX('dadGroup', math.lerp(startingXAlien, endXAlien, math.bound(per, 0, 1)));
		elseif getProperty('inCar') then
			setObjX('dadGroup', getObjX('car') + 130 - (math.floor(182 * 1.01) * upScale) + 8.7192);
		end
	end
	
	
	if walkShoot then
		setObjPos('alienShootWalk', getFixedDadX() + (9 * upScale), getFixedDadY() + (5 * upScale));
	end
	
	if isJumping then
		local l = 289 * e;
		jumpAm = jumpAm + (((8 / 10) / 4) * l);
		local addAmJump = ((jumpAm / 4) * upScale);
		jumpY = jumpY + (addAmJump * l);
		
		if jumpAm > 0 and not fell then
			fell = true;
			alienAnim('fall');
		end
		
		if dadYPos < jumpY then
			onFinishAction();
			isJumping = false;
			walkingAnim = isWalking;
			jumpY = dadYPos;
		end
		
		setObjY('dadGroup', jumpY);
		
		setProperty('alienDad.cameraPosition[1]', -20.5 + math.floor((getFixedDadY() - (600 * upScale)) * -0.5));
	end
	
	for i = 1, #pellets do
		local pel = pellets[i];
		if pel and pel.dieTime <= songPos then
			setObjVelX(pel.tag, 0);
			playAnim(pel.tag, 'splash', true);
			killObjGrp(pel.tag, 'pelletGrp');
			
			table.remove(pellets, i);
		end
	end
	
	setObjPos('flashesGrp', getFixedDadX() + ((isJumping and 166 or 198) * upScale), getFixedDadY() + ((isJumping and -87 or -176) * upScale));
end

function alienNextPosition()
	currentTime = currentTime + 1;
	
	timeTo = alienPositions[currentTime + 1].startWalkingAt;
	
	local currentWalking = alienPositions[currentTime];
	currentWalkAt = currentWalking.startWalkingAt;
	currentWalkEndAt = currentWalking.stopsWalkingAt;
	
	startingXAlien = currentWalking.startX;
	endXAlien = currentWalking.endX;
end

pelletPowerUp = false;
totPellets = 0;
pelletPos = {
	[true] = {166 * upScale, -87 * upScale},
	[false] = {198 * upScale, -176 * upScale}
}
pellets = {};
function makePellet(s, x, y)
	totPellets = totPellets + 1;
	local t = 'alienPELLETShot' .. totPellets;
	local shotOff = pelletPos[isJumping];
	x = x or (getFixedDadX() + shotOff[1]); 
	y = y or (getFixedDadY() + shotOff[2]);
	
	makeAnimatedLuaSprite(t, 'fx/shoot/pow', x, y);
	addAnimationByPrefix(t, 'shot', (pelletPowerUp and 'BIGSHOT' or 'pow'), 24);
	addAnimationByPrefix(t, 'splash', 'Splash', 18, false);
	scaleObject(t, upScale, upScale);
	local cen = getObjCen(t);
	addOffset(t, 'shot', cen[1] + ((pelletPowerUp and 54 or 46) * upScale), cen[2] + ((pelletPowerUp and 56 or 46) * upScale));
	addOffset(t, 'splash', cen[1] + (208 * upScale), cen[2] + (143 * upScale));
	playAnim(t, 'shot', true);
	setObjVelX(t, 289 * upScale * (25 / 4) * playbackRate);
	addToGrp(t, 'pelletGrp');
	
	table.insert(pellets, {
		dieTime = (s or (getSongPosition() + 5000)) + 180,
		tag = t
	});
end

totFlashes = 0;
flashScale = 0.72545454 * upScale;
function makeFlash()
	totFlashes = totFlashes + 1;
	local t = 'alienFLASHES' .. totFlashes;
	
	makeAnimatedLuaSprite(t, 'fx/shoot/gunFlash');
	addAnimationByPrefix(t, 'flash', 'AlienMussleFlashDef', 24, false);
	scaleObject(t, flashScale, flashScale);
	local cen = getObjCen(t);
	addOffset(t, 'flash', cen[1] + (77 * upScale), cen[2] + (137 * upScale));
	playAnim(t, 'flash', true);
	addToGrp(t, 'flashesGrp');
	killObjGrp(t, 'flashesGrp');
end

allWalking = {};
forcedPos = {};
willWalk = false;
function onEventPushed(n, v1, v2, s)
	if walkCheckers[n] then
		willWalk = not willWalk;
		
		table.insert(allWalking, {
			walksAt = s,
			walkSpd = (willWalk and 1 or 0)
		});
	elseif (n == 'Alien Action' and v1 == 'dash') then
		table.insert(allWalking, {
			walksAt = s,
			walkSpd = 5
		});
	elseif (n == 'Alien Force Pos') then
		table.insert(allWalking, {
			walksAt = s,
			walkSpd = 0,
			forcingPos = true
		});
		table.insert(allWalking, {
			walksAt = s + 1,
			walkSpd = (willWalk and 1 or 0)
		});
		
		table.insert(forcedPos, tonumber(v1) * upScale);
	end
	if cacheEvents[n] then 
		cacheEvents[n](v1, v2, s); 
		cacheEvents[n] = nil;
	end
end

cacheEvents = {
	['VICTORY FAKEOUT'] = function()
		local vicScale = 0.72797356 * upScale;
		makeAnimatedLuaSprite('alienFakeout', 'characters/alien/alien-transition', getObjX('dad'), getObjY('dad'));
		addAnimationByPrefix('alienFakeout', 'dash', 'AlienHominidUhOh', 14, false);
		scaleObject('alienFakeout', vicScale, vicScale);
		addOffset('alienFakeout', 'dash', 1150 * vicScale, 16 * vicScale);
		setObjFrameRate('alienFakeout', 'dash', 14.4);
		setObjectOrder('alienFakeout', getObjectOrder('dadGroup'));
		playAnim('alienFakeout', 'dash', true);
		setObjAlpha('alienFakeout', 0.00001);
		
		table.insert(allSpr, 'alienFakeout');
		
		addLuaScript('scriptChars/alienBoss');
	end
}

walkCheckers = {
	['Alien Can Walk'] = true,
}

function onEvent(n, v1, v2, s)
	if events[n] then
		events[n](v1, v2, s);
	end
end

events = {
	['Alien Can Walk'] = function()
		if firstWalk then
			firstWalk = false;
			groundFlip = true;
		end
		
		isWalking = not isWalking;
		setVar('isAlienWalking', isWalking);
		if not isActioning then
			isWatching = false;
			isDashing = false;
			canSing = true;
			
			walkingAnim = isWalking;
			
			setProperty('alienDad.skipDance', false);
			setProperty('alienDad.idleSuffix', '');
			makeCharDance('alienDad');
			
			curWalkFrame = 0;
			
			grounded = not isWalking;
			if grounded then
				canSing = false;
				isWatching = true;
				
				setProperty('alienDad.skipDance', true);
				playAnim('alienDad', 'transition', true);
			end
		end
	end,
	['Alien Action'] = function(v1, v2, s)
		if v1:find('ACTION_') then
			doAction(v1, (v2 == 'true'), s);
		else
			alienAnim(v1);
		end
	end,
	['Alien Action No Spawn'] = function(v1, v2, s)
		if v1:find('ACTION_') then
			doAction(v1, (v2 == 'true'));
		else
			alienAnim(v1);
		end
	end,
	['Car Start'] = function()
		canSing = true;
		setObjAlpha('dadGroup', 0);
	end,
	['Car Explodes'] = function()
		setObjAlpha('dadGroup', 1);
	end,
	['VICTORY'] = function()
		updatePos = false;
		isActioning = true;
		isWatching = false;
		
		alienAnim('hey');
	end,
	['VICTORY FAKEOUT'] = function()
		canSing = true;
		setObjAlpha('dadGroup', 0);
		setObjAlpha('alienFakeout', 1);
		
		setObjX('alienFakeout', getObjX('alienDad'));
		playAnim('alienFakeout', 'dash', true);
	end,
	['Robot EXPLODE'] = function()
		alienAnim('hey');
		setObjAlpha('dadGroup', 1);
		setObjX('dadGroup', (getObjX('bossHominid') + 130) - (math.floor(182 * 1.01) * upScale));
	end
}

function doAction(n, s, st)
	n = n:gsub('ACTION_', '');
	if alienAction[n] then 
		alienAction[n](s, st);
		
		isWatching = false;
		isActioning = true;
	end
end

stabbing = true;
function alienAnim(n)
	playAnim('alienDad', n, true);
	setProperty('alienDad.skipDance', true);
	
	if alienAnimFuncs[n] then alienAnimFuncs[n](); end
end

alienAction = {
	['shoot'] = function(s, st)
		if walkingAnim then
			canSing = false;
			
			alienAnim('walk');
			
			walkShoot = true;
			
			setObjAlpha('alienShootWalk', 1);
			playAnim('alienShootWalk', 'shoot', true);
		end
		if isJumping then
			alienAnim('jump-shoot');
		end
		
		makePellet(st);
		makeFlash();
	end,
	['jump'] = function(s)
		walkingAnim = false;
		canSing = false;
		
		fell = false;
		isJumping = true;
		checkJump = true;
		jumpY = dadYPos;
		jumpAm = -25;
		
		alienAnim('jump');
		if s then doSound('JUMP SFX', 0.5); end
	end,
	['stab'] = function()
		walkingAnim = false;
		canSing = false;
		
		alienAnim('stab');
		stabbing = true;
	end,
	['collectPower'] = function()
		if collectPowerUpKid() then
			pelletPowerUp = true;
			setVar('poweredUp', true);
		end
	end,
	['grabAgent'] = function(_, st)
		if alienTryGrabAgent(getFixedDadX(), st) then
			setObjAlpha('dadGroup', 0);
		end
	end
}

alienAnimFuncs = {
	['stare'] = function()
		setProperty('alienDad.cameraPosition[0]', 306 - (201 * upScale));
	end,
	['dash'] = function()
		isDashing = true;
	end	
}

function opponentNoteHitPre(i, d, n, s)
	if not getPropertyFromGroup('notes', i, 'mustPress') and not canSing then
		setPropertyFromGroup('notes', i, 'noAnimation', true);
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		if groundFlip then
			watched = not watched;
		end
		if isWatching then
			groundAlienDance();
		end
	end
end

function groundAlienDance()
	playAnim('alienDad', (watched and 'watch-left' or 'watch-right'), true);
end

function math.lerp(a, b, ratio) return a + ratio * (b - a); end

function math.bound(x, a, b) return math.min(b, math.max(a, x)); end

allSpr = {};
function destroyCache()
	setObjAlpha('pelletCache', 0);
	setObjAlpha('flashesCache', 0);
	setObjAlpha('alienShootWalk', 0);
	for i = 1, #allSpr do
		setObjAlpha(allSpr[i], 0);
	end
	allSpr = nil;
end
