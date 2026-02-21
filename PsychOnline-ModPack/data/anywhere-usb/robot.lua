upScale = 1 / 0.7;
roboting = false;
mostLeftRobot = 0;
mostRightRobot = 0;
curStop = 0;
function onCreate()
	robotScale = 1.0393617 * upScale;
	createInstance('robot', 'objects.Character', {0, ((544 - 561) * upScale) + 131.62385935, 'robot'});
	scaleObject('robot', robotScale, robotScale);
	resizeOffsets('robot', robotScale);
	playAnim('robot', 'singLEFT', true);
	setProperty('robot.skipDance', true);
	setObjectOrder('robot', getObjectOrder('gfGroup') + 1);
	setObjAlpha('robot', 0.00001);
	
	local deathScale = 1.03829416 * upScale;
	makeAnimatedLuaSprite('robotDEATH', 'characters/robot/ROBOT-DEATH', getObjX('robot'), getObjY('robot'));
	addAnimationByPrefix('robotDEATH', 'hit', 'robotHIT!', 14, false);
	addAnimationByPrefix('robotDEATH', 'shake', 'fuckedfinalbossSHAKE', 21);
	addAnimationByPrefix('robotDEATH', 'explode', 'fuckedfinalbossDEATH', 16, false);
	scaleObject('robotDEATH', deathScale, deathScale);
	addOffset('robotDEATH', 'hit', -10 * deathScale, 75 * deathScale);
	addOffset('robotDEATH', 'shake', 440.5 * deathScale, 168 * deathScale);
	addOffset('robotDEATH', 'explode', 440.5 * deathScale, 168 * deathScale);
	setObjFrameRate('robotDEATH', 'hit', 14.4);
	setObjFrameRate('robotDEATH', 'explode', 16.8);
	playAnim('robotDEATH', 'hit', true);
	setObjectOrder('robotDEATH', getObjectOrder('robot') + 1);
	setObjAlpha('robotDEATH', 0.00001);
	
	if shadersEnabled then
		initLuaShader('CTF Bloom');
		setSpriteShader('robot', 'CTF Bloom');
		setShaderFloat('robot', 'radius', 5);
		setShaderFloat('robot', 'exponent', 2);
		setShaderFloat('robot', 'coeff', 0);
	end
	
	local legsScale = 1.03921568 * upScale;
	makeAnimatedLuaSprite('robotLEGS', 'characters/robot/ROBOT LEGS', 0, 564 * upScale);
	addAnimationByPrefix('robotLEGS', 'idle', 'FBILEGSIDLE', 10, false);
	addAnimationByPrefix('robotLEGS', 'walk', 'FBILEGSWALK', 10);
	addAnimationByPrefix('robotLEGS', 'walkF', 'FBILEGSWALK', 10);
	scaleObject('robotLEGS', legsScale, legsScale);
	local legCen = getObjCen('robotLEGS');
	addOffset('robotLEGS', 'idle', legCen[1] + (185 * upScale), legCen[2] + (157 * upScale));
	addOffset('robotLEGS', 'walk', legCen[1] + (288 * upScale), legCen[2] + (217 * upScale));
	addOffset('robotLEGS', 'walkF', legCen[1] + (289 * upScale), legCen[2] + (217 * upScale));
	setObjFrameRate('robotLEGS', 'idle', 10.4);
	setObjFrameRate('robotLEGS', 'walk', 10.4);
	setObjFlipXAnim('robotLEGS', 'walkF', true);
	playAnim('robotLEGS', 'idle', true);
	setObjectOrder('robotLEGS', getObjectOrder('robot'));
	setObjAlpha('robotLEGS', 0.00001);
	
	runHaxeCode([[
		function setDadRobot() {
			var newDad = getVar('robot');
			setVar('oldDad', game.dad);
			
			game.dad = newDad;
			game.reloadHealthBarColors();
			game.iconP2.changeIcon(newDad.healthIcon);
			game.setOnLuas('dadName', game.dad.curCharacter);
		}
		
		createGlobalCallback('robotGlow', function() {
			parentLua.call('shootRobot', []);
		});
		
		createGlobalCallback('getRobotXProper', function() {
			return parentLua.call('getFixedRobotX', []);
		});
		
		var deathAnim = game.modchartSprites.get('robotDEATH').animation;
		
		deathAnim.callback = function(n, f) { 
			parentLua.call('robotDeathFrame', [n, f]);
		}
		
		deathAnim.finishCallback = function(n) {
			parentLua.call('robotDeathAnim', [n]);
		}
		
		setVar('robotStopped', true);
	]]);
end

singAnims = {};
halfCrochet = 0;
function onCreatePost()
	singAnims = getProperty('singAnimations');
	halfCrochet = (stepCrochet / 2000);
end

function destroyCache()
	setObjAlpha('robotLEGS', 0);
	setObjAlpha('robot', 0);
	setObjAlpha('robotDEATH', 0);
end

moveRobot = true;
isWalking = false;
subToMove = 100;
movementMarker = 0;
curStop = 0;
spawnCam = -10;
unForced = false;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if inGameOver then return; end
	
	if roboting then
		spawnCam = spawnCam - (e * 60);
		if spawnCam > -20 then
			cameraSetTarget('dad');
			setProperty('isCameraOnForcedPos', true);
		elseif not unForced then
			unForced = true
			setProperty('isCameraOnForcedPos', false);
		end
		
		if glowingRobot then
			glowRobotEl = glowRobotEl + e;
			
			if glowRobotEl >= 0.05 then
				glowingRobot = false;
				setShaderFloat('robot', 'coeff', 0);
			end
		end
		
		if holding then
			sustTime = sustTime + e;
			
			if sustTime >= halfCrochet then
				holding = false;
				playAnim('robot', singAnims[prevDir + 1], true);
			end
		end
		
		if moveRobot then
			subToMove = subToMove - (chanLoops * 0.25);
			
			if subToMove <= 0 then
				movementMarker = (movementMarker % 4) + 1;
				subToMove = 100;
				
				if (movementMarker + 1) % 2 == 0 then
					curStop = (movementMarker == 1 and mostRightRobot or mostLeftRobot);
					setVar('robotStopX', curStop - 227.85714142 + (488 * upScale));
				end
			end
			
			local dadX = getObjX('robot');
			
			if math.abs(dadX - curStop) > 10 * upScale then
				robotMove((dadX - curStop > 0));
			else
				stopRobot();
			end
		end
		
		setObjX('robotLEGS', getFixedRobotX() + (15 * upScale));
	end
	chanLoops = 0;
end

chanLoops = 0;
function onChannelLoop(l)
	chanLoops = l;
end

function onBeatHit()
	if roboting and not isWalking and curBeat % 2 == 0 then
		playAnim('robotLEGS', 'idle', true);
	end
end

function getFixedRobotX()
	return (getObjX('robot') - 227.85714142) + (488 * upScale);
end

goingLeft = '';
function robotMove(neg) -- moves the robot left or right, when the robot moves out of bounds
	if goingLeft ~= neg then
		goingLeft = neg;
		stopped = false;
		isWalking = true;
		
		setObjVelX('robot', 289 * upScale * ((neg and -4 or 4) / 4) * playbackRate);
		playAnim('robotLEGS', 'walk' .. (neg and 'F' or ''), true);
		setVar('robotStopped', false);
	end
end

stopped = true;
function stopRobot()
	if not stopped then
		goingLeft = '';
		stopped = true;
		
		setObjVelX('robot', 0);
		
		isWalking = false;
		playAnim('robotLEGS', 'idle', true);
		setVar('robotStopped', true);
	end
end

removedLegs = false;
function robotDeathFrame(n, f)
	if exploding and deathFrames[n] then deathFrames[n](f); end
end

deathFrames = {
	['explode'] = function(f)
		if not removedLegs and f >= 7 then
			removedLegs	 = true;
			roboting = false;
			
			removeLuaSprite('robotLEGS');
		end
	end
}

function robotDeathAnim(n)
	if exploding and deathAnims[n] then deathAnims[n](); end
end

deathAnims = {
	['hit'] = function()
		playAnim('robotDEATH', 'shake', true);
	end,
	['explode'] = function()
		exploding = false;
		removeLuaSprite('robotDEATH');
	end
}

glowingRobot = false;
glowRobotEl = 0;
function shootRobot()
	if not shadersEnabled then return; end
	setShaderFloat('robot', 'coeff', 2);
	
	glowingRobot = true;
	glowRobotEl = 0;
end

prevDir = 0;
sustTime = 0;
holding = false;
function opponentNoteHit(i, d, n, s)
	if noteTypes[n] then noteTypes[n](i, d, s); end
end

noteTypes = {
	[''] = function(i, d, s)
		if dadName ~= 'robot' then return; end
		
		cameraShake('game', 3 / 640, 0.31 / playbackRate);
		if s then
			holding = true;
			prevDir = d;
			sustTime = 0;
		elseif getHealth() > 0.1 then
			addHealth(-2 / 100);
		end
	end
}

exploding = false;
function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Robot Enter'] = function()
		robotEnter();
		
		runHaxeFunction('setDadRobot');
		setObjectOrder('dadGroup', getObjectOrder('robotLEGS') - 1);
		roboting = true;
		setProperty('robot.danceEveryNumBeats', 2);
	end,
	['Robot HIT'] = function()
		moveRobot = false;
		exploding = true;
		
		stopRobot();
		
		setObjAlpha('robot', 0);
		setObjAlpha('robotDEATH', 1);
		setObjX('robotDEATH', getObjX('robot'));
		playAnim('robotDEATH', 'hit', true);
	end,
	['Robot EXPLODE'] = function()
		cameraShake('game', 3 / 1280, 0.5 / playbackRate);
		playAnim('robotDEATH', 'explode', true);
		
		setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') - 1);
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['robotPrep'] = function()
		setProperty('robotLEGS.alpha', 1);
		
		setProperty('robot.skipDance', false);
		makeCharDance('robot');
	end
}

leftOffset = ((640 / 0.7) - 640);
function robotEnter()
	local mostLeftOff = (400 * upScale);
	local mostRightOff = (50 * upScale);
	local robotX = ((getCamScroll() - leftOffset)) + (640 * upScale);
	local robFixX = robotX + 227.85714142 - (488 * upScale);
	setObjX('robot', robFixX);
	playAnim('robot', 'enter', true);
	setProperty('robot.skipDance', true);
	setObjAlpha('robot', 1);
	
	mostLeftRobot = robFixX - mostLeftOff;
	mostRightRobot = robFixX + mostRightOff;
	curStop = robFixX;
	
	setVar('robotStopX', robotX);
	setVar('alienBounds', {robotX - mostLeftOff, robotX + mostRightOff});
	
	runTimer('robotPrep', 0.617 / playbackRate);
end
