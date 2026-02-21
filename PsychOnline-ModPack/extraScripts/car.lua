upScale = 1 / 0.7;
function onCreate()
	carScale = 0.72670807 * upScale;
	makeAnimatedLuaSprite('car', 'interactables/car', 400, 90);
	addAnimationByPrefix('car', 'idle', 'CarAlone', 20);
	addAnimationByPrefix('car', 'go', 'CarGO');
	scaleObject('car', carScale, carScale);
	local carCen = getObjCen('car');
	addOffset('car', 'idle', carCen[1] + (292 * upScale), carCen[2] + (378 * upScale));
	addOffset('car', 'go', carCen[1] + (292 * upScale), carCen[2] + (380 * upScale));
	playAnim('car', 'idle', true);
	setObjectOrder('car', getObjectOrder('gfGroup') + 1);
	setObjAlpha('car', 0.00001);
	
	local bfScale = 0.72521246 * upScale;
	createInstance('carBF', 'objects.Character', {400, 90, 'bf-car'});
	scaleObject('carBF', bfScale, bfScale);
	resizeOffsets('carBF', bfScale);
	setObjFrameRate('carBF', 'idle', 15.6);
	setObjectOrder('carBF', getObjectOrder('car') + 1);
	setObjAlpha('carBF', 0.00001);
	
	local aliScale = 0.725 * upScale;
	createInstance('carAlien', 'objects.Character', {400, 90, 'alien-car'});
	scaleObject('carAlien', aliScale, aliScale);
	resizeOffsets('carAlien', aliScale);
	setObjFrameRate('carAlien', 'idle', 16.8);
	for i, v in pairs({'LEFT', 'DOWN', 'UP', 'RIGHT'}) do
		setObjFrameRate('carAlien', 'sing' .. v, 11.4);
	end
	setObjectOrder('carAlien', getObjectOrder('carBF') + 1);
	setObjAlpha('carAlien', 0.00001);
	
	local exploScale = 1.03897685 * upScale;
	makeAnimatedLuaSprite('carExplode', 'fx/explosion', 200 * upScale, 432 * upScale);
	addAnimationByPrefix('carExplode', 'explode', 'BOOM!', 24, false);
	scaleObject('carExplode', exploScale, exploScale);
	local cen = getObjCen('carExplode');
	addOffset('carExplode', 'explode', cen[1] + (426 * upScale), cen[2] + (434 * upScale));
	playAnim('carExplode', 'explode', true);
	addLuaSprite('carExplode', true);
	setObjAlpha('carExplode', 0.00001);
	
	runHaxeCode([[
		game.modchartSprites.get('car').animation.callback = function(n, f) {
			parentLua.call('onCarFrame', [n, f]);
		}
		
		var inCar = false;
		function setThemToCar() {
			inCar = !inCar;
			
			if (inCar) {
				setVar('tempCarBF', game.boyfriend);
				setVar('tempCarDad', game.dad);
			}
			
			game.dad = getVar((inCar ? 'carAlien' : 'tempCarDad'));
			game.setOnLuas('dadName', game.dad.curCharacter);
			
			game.boyfriend = getVar((inCar ? 'carBF' : 'tempCarBF'));
			game.setOnLuas('boyfriendName', game.boyfriend.curCharacter);
		}
		
		setVar('inCar', false);
	]]);
end

startPos = 9028 * upScale;
function onCreatePost()
	precacheSound('CAR REV UP');
	precacheSound('CAR EXPLO');
end

function destroyCache()
	local carAt = {startPos, 582 * upScale};
	setObjAlpha('car', 1);
	setObjPos('car', carAt[1], carAt[2]);
	setObjPos('carBF', carAt[1] - (336 * upScale) + 6.3571417, carAt[2] - (368 * upScale) + 5.8528925);
	setObjPos('carAlien', carAt[1] - (132 * upScale) + 5.714285, carAt[2] - (399 * upScale) + 6.214285);
	
	setObjAlpha('carBF', 0);
	setObjAlpha('carAlien', 0);
	setObjAlpha('carExplode', 0);
end


function onCarFrame(n, f)
	if YoffPos[n] and YoffPos[n][f] then
		offCarY = YoffPos[n][f] * upScale;
	end
end

offCarY = 0;
isDriving = false;
checkPlode = false;
function onUpdatePost(e)
	if inGameOver then return; end
	
	if isDriving then
		setObjX('car', math.lerp(startPos, toPos, (getSongPosition() - startTime) / (stopTime - startTime)));
		
		local carPos = getObjPos('car');
		setObjPos('carBF', carPos[1] - (336 * upScale) + 6.3571417, carPos[2] - (368 * upScale) + 5.8528925 + offCarY);
		setObjPos('carAlien', carPos[1] - (132 * upScale) + 5.714285, carPos[2] - (399 * upScale) + 6.214285 + offCarY);
		setProperty('carBF.cameraPosition[1]', 173 - offCarY);
		setProperty('carAlien.cameraPosition[1]', 163 - offCarY);
	end
end

function onMoveCamera(f)
	if isDriving then
		setVar('camMoveMult', (f == 'dad' and 2 or 1));
	end
end

YoffPos = {
	['go'] = {
		[0] = 4,
		[1] = 0,
		[2] = 1,
	}
}

startTime = 0;
stopTime = 0;
toPos = 0;
function onEventPushed(n, v1, v2, s)
	if pushedEvents[n] then pushedEvents[n](v1, v2, s) end
end

pushedEvents = {
	['Car Start'] = function(_, _, s)
		startTime = s;
	end,
	['Car Explodes'] = function(_, _, s)
		stopTime = s;
		local totalLoops = songLoopsFromTime(stopTime - startTime);
		toPos = startPos + ((5 / 4) * upScale * totalLoops);
		
		setVar('carStopTime', stopTime);
		setVar('carStartTime', startTime);
		setVar('totalCarDist', toPos - startPos);
		setVar('carStopX', toPos);
	end
}

oldPos = 0;
function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Car Start'] = function()
		isDriving = true;
		setVar('inCar', true);
		
		runHaxeFunction('setThemToCar');
		setObjectOrder('boyfriendGroup', getObjectOrder('carBF'));
		setObjectOrder('dadGroup', getObjectOrder('carAlien'));
		
		playAnim('car', 'go', true);
		
		setObjAlpha('carBF', 1);
		setObjAlpha('carAlien', 1);
		
		doSound('CAR REV UP', 0.75);
	end,
	['Car Explodes'] = function()
		isDriving = false;
		setVar('inCar', false);
		
		runHaxeFunction('setThemToCar');
		setObjectOrder('boyfriendGroup', getObjectOrder('bfOtherSide') - 1);
		setObjectOrder('dadGroup', getObjectOrder('bfLayer') + 2);
		
		setVar('camMoveMult', 1);
		
		setObjAlpha('car', 0);
		
		setObjAlpha('carBF', 0);
		setObjAlpha('carAlien', 0);
		
		triggerEvent('Add Camera Zoom', '', '');
		cameraShake('game', 3 / 640, 0.15 / playbackRate);
		
		setObjectOrder('carExplode', getObjectOrder('fgBuildGrpF') - 1);
		setObjX('carExplode', getObjX('car'));
		setObjAlpha('carExplode', 1);
		playAnim('carExplode', 'explode', true);
		removeObjOnFinishAnim('carExplode');
		
		doSound('CAR EXPLO', 0.3);
	end
}

carAnims = {
	['go'] = function(frame)
		if carFrames[frame] then
			carFrames[frame]()
		end
	end
}

function math.lerp(a, b, ratio) return a + ratio * (b - a); end
