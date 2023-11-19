upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	skitScaleStand = 0.674513 * upScale * 1.3;
	makeAnimatedLuaSprite('skittleStand', 'wasteland/skittles/skittlestand', 0, -1429 * upScale);
	addAnimationByPrefix('skittleStand', 'stand', 'SkittlesStand', 0, false);
	scaleObject('skittleStand', skitScaleStand, skitScaleStand);
	playAnim('skittleStand', 'stand', true);
	addLuaSprite('skittleStand', true);
	setProperty('skittleStand.alpha', 0.00001);
	
	skitTowScale = 0.9623397 * upScale;
	makeAnimatedLuaSprite('skittleHut', 'wasteland/skittles/skittlehut');
	addAnimationByIndices('skittleHut', 'idle', 'PrivateSkittlesHut', '1,1', 30);
	addAnimationByIndices('skittleHut', 'prepSpit', 'PrivateSkittlesHut', '2,3,4,5,6', 15);
	addAnimationByIndices('skittleHut', 'spit', 'PrivateSkittlesHut', '7,8,9,10,11', 15);
	scaleObject('skittleHut', skitTowScale, skitTowScale);
	playAnim('skittleHut', 'idle', true);
	setObjectOrder('skittleHut', getObjectOrder('skittleStand') + 1);
	setProperty('skittleHut.alpha', 0.00001);
end

function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Pan To Skittles'] = function()
		setProperty('skittleStand.alpha', 1);
		setProperty('skittleHut.alpha', 1);
		
		setProperty('skittleStand.x', (1409 + 15000) * upScale);
		setProperty('skittleHut.x', (1409 + 15000 - 62) * upScale);
		setProperty('skittleHut.y', (-1429 - 811) * upScale);
		
		setProperty('camFollow.x', 16690 * upScale);
		setProperty('camFollow.y', -1720 * upScale);
		
		startTween('panSkittle', 'camGame.scroll', {x = (16886 * upScale) - (screenWidth / 2), y = (-1720 * upScale) - (screenHeight / 2)}, 5 / playbackRate, {ease = 'quadInOut'});
	end,
	['Skittles Spit'] = function(v1)
		playAnim('skittleHut', v1, true);
	end,
	['Skittles Pan Down'] = function()
		checkHit = true;
		cancelTween('panSkittle');
		setProperty('camFollow.y', (-1720 + 800) * upScale);
		doTweenY('panSkittleY', 'camGame.scroll', ((-1720 + 800) * upScale) - (screenHeight / 2), 0.4 / playbackRate, 'quadin');
		runTimer('skitMove2', 0.5 / playbackRate);
	end
}

checkHit = false;
function onUpdatePost()
	if checkHit then
		if getProperty('tank.x') + (427 * upScale) > getProperty('skittleStand.x') + (126 * 1.3 * upScale) then
			playAnim('skittleStand', 'stand', true, false, 1);
			checkHit = false;
		end
	end
end

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['skitMove2'] = function()
		isDownMove = true;
		doTweenY('panSkittleDown2PosY', 'camGame.scroll', ((-1720 + 1600) * upScale) - (screenHeight / 2), 0.4 / playbackRate, 'quadout');
	end
}
