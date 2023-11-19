trickActive = false;
randStatics = false;
upScale = 1 / 0.7;
trickScale = 0.83079268 * upScale;
trickyPos = {};
engageHellClown = {
	['Fucked'] = true,
}
function onCreatePost()
	luaDebugMode = true;
	
	precacheSound('Screamfade');
	precacheSound('hellclownarrives');
	
	addLuaScript('extraScripts/tricky static');
	
	createInstance('tricky', 'objects.Character', {((717 - 272) * upScale) + 61.28571, ((176 - 224) * upScale) + 50.26175, 'tricky'});
	scaleObject('tricky', trickScale, trickScale);
	resizeOffsets('tricky', trickScale);
	setObjectOrder('tricky', getObjectOrder('gfGroup') + 3);
	setObjAlpha('tricky', 0.00001);
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		setVar("hellclownAppeared", false);
		
		createGlobalCallback('killTricky', function() {
			parentLua.call('trickyDies', []);
		});
		
		createCallback('setObjFinAnim', function(o, f) {
			var b = LuaUtils.getObjectDirectly(o, false);
			
			b.animation.finishCallback = function(n) {
				parentLua.call(f, [o, n]);
			}
		});
		
		var tricky = getVar('tricky');
		function trickyDance()
			if (tricky.animation.curAnim != null && !tricky.stunned && game.curBeat % tricky.danceEveryNumBeats == 0 && 
				!StringTools.startsWith(tricky.animation.curAnim.name, 'sing')) 
				tricky.dance();
		
		function trickySingTimer()
			tricky.holdTimer = 0;
		
		function trickySing(d) {
			tricky.playAnim(game.singAnimations[d], true);
			trickySingTimer();
		}
		
		function trickyKilled() {
			tricky.kill();
			tricky.destroy();
		}
	]]);
	
	trickyPos = getObjPos('tricky');
	
	makeAnimatedLuaSprite('trickyEnter', 'characters/tricky/tricky-enter', trickyPos[1], trickyPos[2]);
	addAnimationByPrefix('trickyEnter', 'enter', 'trickyentrance', 18, false);
	scaleObject('trickyEnter', trickScale, trickScale);
	addOffset('trickyEnter', 'enter', 220 * trickScale, 467 * trickScale);
	setObjectOrder('trickyEnter', getObjectOrder('tricky'));
	playAnim('trickyEnter', 'enter', true);
	setObjAlpha('trickyEnter', 0.00001);
	
	makeAnimatedLuaSprite('trickyScreams', 'characters/tricky/tricky-scream', trickyPos[1], trickyPos[2]);
	addAnimationByPrefix('trickyScreams', 'screaming', 'trickyentrance', 25, false);
	scaleObject('trickyScreams', trickScale, trickScale);
	addOffset('trickyScreams', 'screaming', 137 * trickScale, 56 * trickScale);
	setObjFrameRate('trickyScreams', 'screaming', 25.2);
	playAnim('trickyScreams', 'screaming', true);
	setObjectOrder('trickyScreams', getObjectOrder('tricky'));
	setObjAlpha('trickyScreams', 0.00001);
	
	makeAnimatedLuaSprite('trickyTurns', 'characters/tricky/tricky-turn', trickyPos[1], trickyPos[2]);
	addAnimationByPrefix('trickyTurns', 'turn', 'trickyturning', 18, false);
	scaleObject('trickyTurns', trickScale, trickScale);
	addOffset('trickyTurns', 'turn', -8.5 * trickScale, 18 * trickScale);
	setObjectOrder('trickyTurns', getObjectOrder('tricky'));
	playAnim('trickyTurns', 'turn', true);
	setObjAlpha('trickyTurns', 0.00001);
	
	makeAnimatedLuaSprite('trickyFlails', 'characters/tricky/tricky-flail', 740 * upScale, 131 * upScale);
	addAnimationByPrefix('trickyFlails', 'flail', 'tikygetsshot', 30);
	scaleObject('trickyFlails', 0.89118457 * upScale, 0.89118457 * upScale);
	local trickyCen = getObjCen('trickyFlails');
	addOffset('trickyFlails', 'flail', trickyCen[1] + (323 * upScale), trickyCen[2] + (344 * upScale));
	playAnim('trickyFlails', 'flail', true);
	setObjectOrder('trickyFlails', getObjectOrder('tricky'));
	setObjAlpha('trickyFlails', 0.00001);
	
	makeAnimatedLuaSprite('tikyBlood', 'nevada/blood', (640 - 206) * upScale, (526 - 411) * upScale);
	addAnimationByPrefix('tikyBlood', 'blood', 'BloodSplash', 30, false);
	scaleObject('tikyBlood', upScale, upScale);
	local bloodCen = getObjCen('tikyBlood');
	addOffset('tikyBlood', 'blood', bloodCen[1] + (190 * upScale), bloodCen[2] + (190 * upScale));
	playAnim('tikyBlood', 'blood', true);
	setObjectOrder('tikyBlood', getObjectOrder('dadGroup') + 1);
	setObjAlpha('tikyBlood', 0.00001);
	
	if engageHellClown[difficultyName] then
		addLuaScript('extraScripts/hellclown');
	end
	
	runTimer('trickyRandStatics', 0.25 / playbackRate, 0);
	runTimer('trickyRandEnterStatics', 0.56 / playbackRate, 0); -- ???? why?? i dont even know
end

function onBeatHit()
	if trickActive then runHaxeFunction('trickyDance'); end
end

isFlailing = false; -- alterable value B
trickyFlailAmount = 32 -- alterable value A
trickyOffset = 0; -- alterable value D
trickOrdered = false;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if not inGameOver then
		if isFlailing then
			local trickyY = (131 * upScale) - (trickyOffset * upScale);
			
			if trickyY < -500 * upScale then
				isFlailing = false;
				removeLuaSprite('trickyFlails');
				
				goto ENDOFFLAIL;
			end
			
			setObjPos('trickyFlails', 740 * upScale, trickyY);
			
			trickyOffset = trickyOffset + (trickyFlailAmount * (e / 0.02));
			trickyFlailAmount = trickyFlailAmount - (2 * (e / 0.02));
			
			if not trickOrdered and trickyFlailAmount <= -1 then 
				trickOrdered = true;
				
				setObjectOrder('trickyFlails', getObjectOrder('cliff') + 1);
			end
			::ENDOFFLAIL::
		end
	end
end

function trickyDies()
	doSound('Screamfade');
	
	isFlailing = true;
	setObjAlpha('trickyFlails', 1);
	playAnim('trickyFlails', 'flail', true);
	
	setObjAlpha('tikyBlood', 1);
	playAnim('tikyBlood', 'blood', true);
	setObjFinAnim('tikyBlood', 'trickyFinAnims');
	
	triggerStatic('HAY!!!', 0.24, {316, 248});
	
	trickActive = false;
	runHaxeFunction('trickyKilled');
	
	removeLuaSprite('trickyTurns');
end

function opponentNoteHit(i, d, n, s)
	if noteTypes[n] then noteTypes[n](i, d, s); end
end

noteTypes = {
	['trickyNotes'] = function(i, d, s)
		if not trickActive then return; end
		if s then
			runHaxeFunction('trickySingTimer');
		else
			runHaxeFunction('trickySing', {d});
		end
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['trickyRandStatics'] = function()
		if randStatics and getRandomInt(1, 6) == 1 then
			triggerStatic();
		end
	end,
	['trickyRandEnterStatics'] = function()
		if enterStatics and getRandomInt(1, 10) == 1 then
			triggerStatic();
		end
	end
}

zoomedInTrick = false;
function onEvent(n)
	if events[n] then
		events[n]();
	end
end

events = {
	['Tricky Enter'] = function()
		triggerStatic('CLOWN ENGAGED!', 0.29, {249, 244});
		
		enterStatics = true;
		
		setObjAlpha('trickyEnter', 1);
		playAnim('trickyEnter', 'enter', true);
		setObjFinAnim('trickyEnter', 'trickyFinAnims');
	end,
	['Tricky Screams'] = function()
		setObjAlpha('tricky', 0.00001);
		
		setObjAlpha('trickyScreams', 1);
		playAnim('trickyScreams', 'screaming', true);
		setObjFinAnim('trickyScreams', 'trickyFinAnims');
	end,
	['Tricky Turn To Hank'] = function()
		randStatics = false;
		cancelTimer('trickyRandStatics');
		
		setObjAlpha('tricky', 0.00001);
		
		setObjAlpha('trickyTurns', 1);
		playAnim('trickyTurns', 'turn', true);
	end
}

function trickyFinAnims(o, n)
	removeLuaSprite(o);
	
	if showTrickyFin[o] then setObjAlpha('tricky', 1); end
	if finFuncs[o] then finFuncs[o](); end
end

showTrickyFin = {
	['trickyEnter'] = true,
	['trickyScreams'] = true
}

finFuncs = {
	['trickyEnter'] = function()
		enterStatics = false;
		cancelTimer('trickyRandEnterStatics');
		
		randStatics = true;
		
		trickActive = true;
		runHaxeFunction('trickyDance');
	end,
	['trickyScreams'] = function()
		runHaxeFunction('trickyDance');
	end
}
