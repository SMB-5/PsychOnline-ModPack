upScale = 1 / 0.7;
bfScale = 0.72553699 * upScale * 1.01;
function onCreate()
	luaDebugMode = true;
	
	local bfPos = {((886 - math.floor(151 * 1.01)) * upScale) + 9.81428485, ((616 - math.floor(292 * 1.01)) * upScale) + 9.46293814};
	createInstance('bfOtherSide', 'objects.Character', {bfPos[1], bfPos[2], 'bf-otherside'});
	scaleObject('bfOtherSide', bfScale, bfScale);
	resizeOffsets('bfOtherSide', bfScale);
	setProperty('bfOtherSide.isPlayer', true);
	setObjFrameRate('bfOtherSide', 'idle', 14.4);
	setObjFrameRate('bfOtherSide', 'hey', 14.4);
	setObjFrameRate('bfOtherSide', 'jump', 14.4);
	setObjAlpha('bfOtherSide', 0.00001);
	
	runHaxeCode([[
		import psychlua.LuaUtils;
		import substates.GameOverSubstate;
		
		createGlobalCallback('bfXProper', function() {
			return parentLua.call('getFixedBfX', []);
		});
		
		function setBfToWalker() {
			setVar('bfOLD', game.boyfriend);
			
			game.boyfriend = getVar('bfOtherSide');
		}
		
		function setBFBack() {
			var toTake = getVar('bfOLD');
			setVar('bfOLD', game.boyfriend);
			
			game.boyfriend = toTake;
		}
		
		createCallback('onFinAnim', function(o) {
			var obj = LuaUtils.getObjectDirectly(o, false);
			obj.animation.finishCallback = function(n) {
				if (obj.alpha > 0.00001) parentLua.call('bfFinishAnim', [n]);
			}
		});
		
		createCallback('getDeathName', function() {
			return GameOverSubstate.characterName;
		});
		
		createCallback('setDeathTo', function(o) {
			GameOverSubstate.characterName = o;
		});
	]]);
end

canSing = true;
deathName = '';
function onCreatePost()
	singAnims = getProperty('singAnimations');
	
	setObjectOrder('bfOtherSide', getObjectOrder('dadGroup') + 1);
	
	makeAnimatedLuaSprite('BFDodge', 'characters/boyfriend/bf-dodge', getObjX('boyfriend'), getObjY('boyfriend'));
	addAnimationByPrefix('BFDodge', 'dodge', 'boyfriend dodge', 9, false);
	addAnimationByPrefix('BFDodge', 'react', 'boyfriend react', 12, false);
	addOffset('BFDodge', 'dodge', -7, -12);
	addOffset('BFDodge', 'react', -8, -3);
	playAnim('BFDodge', 'dodge', true);
	setObjectOrder('BFDodge', getObjectOrder('dadGroup') - 1);
	setObjAlpha('BFDodge', 0.00001);
	
	makeLuaSprite('bfLayer');
	setObjectOrder('bfLayer', getObjectOrder('boyfriendGroup'));
	setObjAlpha('bfLayer', 0);
	
	calcMove();
end

bfPositions = {};
currentTime = 0;
timeTo = 0;

startingXBF = 0;
endXBF = 0;

currentWalkAt = 0;
currentWalkEndAt = 0;
function calcMove()
	local bfStartPos = getObjX('bfOtherSide');
	local bfOffset = -((math.floor(151 * 1.01) * upScale) + 9.81428485); 
	local addedEmtCar = false;
	
	for i = 1, #allWalking do
		local walkWhen = allWalking[i].walksAt;
		local nextIndex = allWalking[i + 1];
		
		local bfStartX = bfStartPos;
		local addXBF = 0;
		
		local durCar = walkWhen >= getProperty('carStartTime') and walkWhen <= getProperty('carStopTime');
		local nextDurCar = (nextIndex and nextIndex.walksAt >= getProperty('carStartTime') and nextIndex.walksAt <= getProperty('carStopTime'));
		
		if durCar and nextDurCar then
			if not addedEmtCar then
				table.insert(bfPositions, {
					startX = bfStartX,
					endX = bfStartX,
					
					startWalkingAt = getProperty('carStartTime'),
					stopsWalkingAt = getProperty('carStartTime'),
				});
				
				addedEmtCar = true;
			end
			goto loopCont;
		end
		
		if nextDurCar then
			nextIndex.walksAt = getProperty('carStartTime');
		end
		
		if durCar and (nextIndex and nextIndex.walksAt >= getProperty('carStopTime')) then	
			addXBF = getProperty('carStopX') - (287 * upScale) + bfOffset - bfStartX;
			
			table.insert(bfPositions, {
				startX = bfStartX + addXBF,
				endX = bfStartX + addXBF,
				
				startWalkingAt = walkWhen,
				stopsWalkingAt = nextIndex.walksAt,
			});
			
			goto preloopCont;
		end
		
		addXBF = addXBF + ((allWalking[i].walkSpd > 0) and (allWalking[i].walkSpd * upScale * (songLoopsFromTime((nextIndex and nextIndex.walksAt or (songLength + 1000)) - walkWhen))) or 0);
		
		table.insert(bfPositions, {
			startX = bfStartX,
			endX = bfStartPos + addXBF,
			
			startWalkingAt = walkWhen,
			stopsWalkingAt = (nextIndex and nextIndex.walksAt or (songLength + 1000))
		});
		
		::preloopCont::
		
		bfStartPos = bfStartPos + addXBF;
		
		::loopCont::
	end
	
	table.insert(bfPositions, {
		startX = 0,
		endX = 0,
		
		startWalkingAt = 999999,
		stopsWalkingAt = 999999
	});
	
	currentTime = 0; -- current time to check for
	timeTo = bfPositions[1].startWalkingAt; -- next time to go to
	
	currentWalkAt = 0;
	currentWalkEndAt = 0;
	
	startingXBF = getObjX('bfOtherSide');
	endXBF = getObjX('bfOtherSide');
end

curWalkFrame = 0;
isWalking = false;
walkingAnim = false;

dodged = false;
looked = true;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if inGameOver then return; end
	
	if getSongPosition() >= timeTo then
		BFNextPosition();
	end
	
	if getObjX('bfOtherSide') ~= endXBF and not getProperty('inCar') then
		local per = (getSongPosition() - currentWalkAt) / (currentWalkEndAt - currentWalkAt);
		setObjX('bfOtherSide', math.lerp(startingXBF, endXBF, math.bound(per, 0, 1)));
	elseif getProperty('inCar') then
		setObjX('bfOtherSide', getObjX('car') - ((math.floor(151 * 1.01) + 300) * upScale) + 9.81428485);
	end
	
	if walkingAnim then
		curWalkFrame = curWalkFrame + (e * 12);
		local bfWalkFrame =  math.floor(curWalkFrame % 5);
		
		setCurFrame('bfOtherSide', bfWalkFrame);
	end
	
	if not dodged and ((886 - math.floor(151 * 1.01)) * upScale) < (dadXProper() + (200 * upScale)) then
		dodged = true;
		looked = false;
		
		setObjAlpha('BFDodge', 1);
		setObjAlpha('boyfriendGroup', 0.00001);
		
		playAnim('BFDodge', 'dodge', true);
		doTweenY('boyfriendOUTOFWAY', 'BFDodge', getObjY('BFDodge') - (32 * upScale), 0.17 / playbackRate, 'quadOut');
	end
	
	if not looked and (886 * upScale) < (dadXProper() - (150 * upScale)) then
		looked = true;
		
		playAnim('BFDodge', 'react', true);
	end
end

function BFNextPosition()
	currentTime = currentTime + 1;
	
	timeTo = bfPositions[currentTime + 1].startWalkingAt;
	
	local currentWalking = bfPositions[currentTime];
	currentWalkAt = currentWalking.startWalkingAt;
	currentWalkEndAt = currentWalking.stopsWalkingAt;
	
	startingXBF = currentWalking.startX;
	endXBF = currentWalking.endX;
end

function bfFinishAnim(n)
	if finAnims[n] then finAnims[n](); end
end

finAnims = {
	['dash'] = function()
		setObjAlpha('boyfriendGroup', 1);
		setObjX('boyfriendGroup', getObjX('bfOtherSide') + ((282 + 404 - 117) * upScale));
		setObjY('boyfriendGroup', getObjY('bfOtherSide') - (220 * upScale));
		
		setDeathTo(deathName);
		
		setProperty('boyfriendCameraOffset[0]', -144 + (90 * upScale));
		setProperty('boyfriendCameraOffset[1]', -38.5 - (51 * upScale));
		
		removeLuaSprite('bfFakeOut');
		addToX('bfOtherSide', 300 * upScale);
		
		runHaxeFunction('setBFBack');
		
		characterDance('boyfriend');
	end
}

function getFixedBfX()
	return getObjX('bfOtherSide') + (math.floor(151 * 1.01) * upScale) - 9.81428485;
end

function goodNoteHitPre(i, d, n, s)
	if getPropertyFromGroup('notes', i, 'mustPress') and not canSing then
		setPropertyFromGroup('notes', i, 'noAnimation', true);
	end
end

allWalking = {};
willWalk = false;
function onEventPushed(n, v1, v2, s)
	if walkCheckers[n] then
		willWalk = not willWalk;
		
		table.insert(allWalking, {
			walksAt = s,
			walkSpd = (willWalk and 1 or 0)
		});
	end
	if cacheEvents[n] then 
		cacheEvents[n](v1, v2, s); 
		cacheEvents[n] = nil;
	end
end

cacheEvents = {
	['VICTORY FAKEOUT'] = function()
		makeAnimatedLuaSprite('bfFakeOut', 'characters/boyfriend/bf-transition', getObjX('bfOtherSide'), getObjY('bfOtherSide'));
		addAnimationByPrefix('bfFakeOut', 'dash', 'BFOthersideUhoh', 18, false);
		scaleObject('bfFakeOut', bfScale, bfScale);
		addOffset('bfFakeOut', 'dash', -5 * bfScale, 37 * bfScale);
		playAnim('bfFakeOut', 'dash', true);
		addLuaSprite('bfFakeOut', true);
		setObjAlpha('bfFakeOut', 0.00001);
		onFinAnim('bfFakeOut');
	end,
	['BF Prep Mic'] = function()
		makeAnimatedLuaSprite('BFMicPrep', 'characters/boyfriend/bf-prepMic', getObjX('boyfriend'), getObjY('boyfriend'));
		addAnimationByPrefix('BFMicPrep', 'prep', 'bf pre attack', 29);
		addOffset('BFMicPrep', 'prep', -39, -38);
		setObjFrameRate('BFMicPrep', 'prep', 28.8);
		setLoopPoint('BFMicPrep', 'prep', 7);
		playAnim('BFMicPrep', 'prep', true);
		setObjectOrder('BFMicPrep', getObjectOrder('boyfriendGroup'));
		setObjAlpha('BFMicPrep', 0.00001);
	end,
	['BF Catches GF'] = function()
		makeAnimatedLuaSprite('BFCatchGF', 'characters/boyfriend/bf-catchGF', getObjX('boyfriend'), getObjY('boyfriend'));
		addAnimationByPrefix('BFCatchGF', 'catch', 'BFCatchingGF', 14, false);
		addOffset('BFCatchGF', 'catch', 156, 883);
		setObjFrameRate('BFCatchGF', 'catch', 14.4);
		playAnim('BFCatchGF', 'catch', true);
		setObjectOrder('BFCatchGF', getObjectOrder('boyfriendGroup'));
		setObjAlpha('BFCatchGF', 0.00001);
	end
}

walkCheckers = {
	['Boyfriend Can Walk'] = true,
}

firstWalk = false;
function onEvent(n, v1, v2)
	if events[n] then
		events[n](v1, v2);
	end
end

events = {
	['Boyfriend Can Walk'] = function()
		if not firstWalk then 
			firstWalk = true;
			removeLuaSprite('BFDodge');
			
			deathName = getDeathName();
			setDeathTo('bf-othersideDEAD');
			
			setObjAlpha('bfOtherSide', 1);
			runHaxeFunction('setBfToWalker');
			setObjectOrder('boyfriendGroup', getObjectOrder('bfOtherSide') - 1);
		end
		
		if not isWalking then 
			canSing = true;
			setProperty('bfOtherSide.skipDance', false); 
		end
		
		isWalking = not isWalking;
		walkingAnim = isWalking;
		
		if isWalking then
			canSing = true;
			if getCurAnim('bfOtherSide'):find('idle') then
				playAnim('bfOtherSide', 'singRIGHT', true);
			end
		else
			makeCharDance('bfOtherSide');
		end
		
		curWalkFrame = 0;
	end,
	['BF Jumps Into Car'] = function()
		canSing = false;
		walkingAnim = false;
		playAnim('bfOtherSide', 'jump', true);
		setProperty('bfOtherSide.skipDance', true);
	end,
	['Car Start'] = function()
		canSing = true;
		setObjAlpha('bfOtherSide', 0.00001);
	end,
	['Car Explodes'] = function()
		setObjAlpha('bfOtherSide', 1);
	end,
	['VICTORY'] = function()
		canSing = false;
		walkingAnim = false;
		playAnim('bfOtherSide', 'hey', true);
		setProperty('bfOtherSide.skipDance', true);
	end,
	['VICTORY FAKEOUT'] = function()
		canSing = true;
		setObjectOrder('bfFakeOut', getObjectOrder('bfOtherSide'));
		setObjAlpha('bfFakeOut', 1);
		setObjX('bfFakeOut', getObjX('bfOtherSide'));
		playAnim('bfFakeOut', 'dash', true);
		
		setObjAlpha('bfOtherSide', 0);
	end,
	['Play Animation'] = function(v1, v2)
		if v2 == 'boyfriend' and v1 == 'attack' then
			canSing = false;
			removeLuaSprite('BFMicPrep');
			setObjAlpha('boyfriend', 1);
		end
	end,
	['BF Prep Mic'] = function()
		setObjectOrder('BFMicPrep', getObjectOrder('bfOtherSide'));
		setObjPos('BFMicPrep', getObjX('boyfriend'), getObjY('boyfriend'));
		setObjAlpha('BFMicPrep', 1);
		setObjAlpha('boyfriend', 0.00001);
		
		playAnim('BFMicPrep', 'prep', true);
	end,
	['BF Catches GF'] = function()
		setObjectOrder('BFCatchGF', getObjectOrder('bfOtherSide'));
		setObjPos('BFCatchGF', getObjX('boyfriend'), getObjY('boyfriend'));
		setObjAlpha('BFCatchGF', 1);
		setObjAlpha('boyfriend', 0.00001);
		
		playAnim('BFCatchGF', 'catch', true);
	end
}

function math.lerp(a, b, ratio) return a + ratio * (b - a); end

function math.bound(x, a, b) return math.min(b, math.max(a, x)); end

function destroyCache()
	setObjAlpha('bfOtherSide', 0);
	setObjAlpha('BFDodge', 0);
end
