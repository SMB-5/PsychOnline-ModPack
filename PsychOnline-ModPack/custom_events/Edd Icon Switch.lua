function onCreatePost()
	luaDebugMode = true;
	
	createInstance('iconP3', 'objects.HealthIcon', {getProperty('dad.healthIcon')});
	setProperty('iconP3.visible', getProperty('iconP1.visible'));
	setObjAlpha('iconP3', 0.00001);
	setObjectCamera('iconP3', 'hud');
	
	runHaxeCode([[
		var lastFrame = 0;
		game.iconP1.animation.callback = function(_, f) {
			if (f != lastFrame) {
				lastFrame = f;
				parentLua.call('onIconChange', [f]);
			}
		}
		
		game.uiGroup.insert(3, getVar('iconP3'));
	]]);
end

function onSongStart()
	setObjAlpha('iconP3', 0);
end

function onIconChange()
	if canFunc then
		setCurFrame('iconP3', getCurFrame('iconP1'));
	end
end

canFunc = true;
function onUpdatePost(e)
	if not inGameOver and canFunc then
		scaleObject('iconP3', getProperty('iconP1.scale.x'), getProperty('iconP1.scale.x'));
		setProperty('iconP3.origin.x', getProperty('iconP1.origin.x') - 76);
		setProperty('iconP3.origin.y', getProperty('iconP1.origin.y') - (downscroll and 40 or -65));
		
		local icoPos = getObjPos('iconP1');
		setObjPos('iconP3', icoPos[1] + 76, icoPos[2] + (downscroll and 40 or -65));
	end
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Edd Icon Switch'] = function()
		canFunc = false;
		setObjAlpha('iconP3', 1);
		
		local icoPos = getObjPos('iconP2');
		setObjPos('iconP3', icoPos[1], icoPos[2]);
		setCurFrame('iconP3', getCurFrame('iconP2'));
		
		startTween('iconMoveTo', 'iconP3', {x = getObjX('iconP1') + 76, y = getObjY('iconP1') + (downscroll and 40 or -65)}, 0.23 / playbackRate, {ease = 'QuadOut', onComplete = 'onTweenCompleted'});
		runTimer('iconAdjust', 0.165 / playbackRate);
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['iconAdjust'] = function()
		setCurFrame('iconP3', getCurFrame('iconP1'));
		setProperty('iconP3.flipX', true);
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['iconMoveTo'] = function()
		canFunc = true;
	end
}
