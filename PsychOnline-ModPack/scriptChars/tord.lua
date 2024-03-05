upScale = 1 / 0.7
function onCreate()
	luaDebugMode = true;
	
	makeLuaSprite('tordBG', 'eddsworld/end mix/tord/tordBG', 672 - 1003, 338 - 701);
	setScrollFactor('tordBG');
	addLuaSprite('tordBG', true);
	setObjAlpha('tordBG', 0.00001);
	
	tordPos = {620 - 676, 470 - 507};
	createInstance('tord', 'objects.Character', {tordPos[1], tordPos[2], 'tord'});
	setObjFrameRate('tord', 'pissed', 13.2);
	setObjFrameRate('tord', 'pissed-loop', 13.2);
	setScrollFactor('tord');
	addInstance('tord', true);
	setObjAlpha('tord', 0.00001);
	setProperty('tord.skipDance', true);
	playAnim('tord', 'hey', true);
	
	makeAnimatedLuaSprite('tord-buttonPress', 'characters/tord/tord-buttonpress', tordPos[1], tordPos[2]);
	addAnimationByPrefix('tord-buttonPress', 'prep', 'TordRaiseThumbs', 13, false);
	addAnimationByPrefix('tord-buttonPress', 'press', 'TordButtonPress', 13, false);
	setObjFrameRate('tord-buttonPress', 'prep', 13.2);
	setObjFrameRate('tord-buttonPress', 'press', 12.6);
	addOffset('tord-buttonPress', 'prep', 0, 24);
	addOffset('tord-buttonPress', 'press', 0, 24);
	playAnim('tord-buttonPress', 'prep', true);
	setScrollFactor('tord-buttonPress');
	setObjectOrder('tord-buttonPress', getObjectOrder('tord') + 1);
	setObjAlpha('tord-buttonPress', 0.00001);
	
	makeAnimatedLuaSprite('tord-ending', 'characters/tord/tord-ending', tordPos[1], tordPos[2]);
	addAnimationByPrefix('tord-ending', 'hit', 'TordHarpoonShot', 17);
	addAnimationByPrefix('tord-ending', 'ohNo', 'TordOhNo', 24, false);
	setObjFrameRate('tord-ending', 'hit', 16.8);
	setLoopPoint('tord-ending', 'hit', 5);
	addOffset('tord-ending', 'hit', 0, 38);
	addOffset('tord-ending', 'ohNo', -0.3, 32.5);
	playAnim('tord-ending', 'ohNo', true);
	setScrollFactor('tord-ending');
	setObjectOrder('tord-ending', getObjectOrder('tord') + 1);
	setObjAlpha('tord-ending', 0.00001);
	
	makeLuaSprite('tordGlass', 'eddsworld/end mix/tord/tordGlass', 624 - 720, 430 - 449);
	scaleObject('tordGlass', 2, 2, false);
	setScrollFactor('tordGlass');
	addLuaSprite('tordGlass', true);
	setObjAlpha('tordGlass', 0.00001);
	
	runHaxeCode([[
		setVar('oldDad', game.dad);
		
		function setTordDad() {
			setVar('oldDad', game.dad);
			game.dad = getVar('tord');
			game.setOnScripts('dadName', game.dad.curCharacter);
		}
		game.modchartSprites.get('tord-buttonPress').animation.finishCallback = function(n) parentLua.call('onTBFinAnim', [n]);
	]]);
	
	singTable = getProperty('singAnimations');
end

function onSongStart()
	setObjAlpha('tord', 0);
	setObjAlpha('tord-buttonPress', 0);
	setObjAlpha('tord-ending', 0);
	setObjAlpha('tordBG', 0);
	setObjAlpha('tordGlass', 0);
end

function onTBFinAnim(n)
	if n == 'press' then
		setObjAlpha('tord-buttonPress', 0);
		setObjAlpha('tord', 1);
	end
end

singTable = {};
stoppedShake = false;
alertColor = false;
harpoonShake = false;
harpshakeAm = 15;
glassScale = 2;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if alertColor then
		local timer = getSongPosition() + (crochet * 5);
		local colPercent = (math.sin(math.rad(timer / 1.8)) + 1) / 2; -- conversion to radians
		local colorTo = RGBToHex({255, math.floor(math.lerp(255, 193, colPercent)), math.floor(math.lerp(254, 194, colPercent))});
		setObjectColor('tordBG', colorTo);
		setObjectColor('tord-ending', colorTo);
	end
	
	if scalingGlassTord then
		glassScale = glassScale * (1 + (0.3 * (e * 60)));
		
		scaleObject('tordGlass', glassScale, glassScale, false);
	end
	
	if hitNote then
		tordHTimer = tordHTimer - (1.9 * (e / 0.01));
		if tordHTimer > 0 then
			local shakeAm = math.floor(tordHTimer / 8);
			cameraShake('game', shakeAm / 640, 0.1 / playbackRate);
			stoppedShake = false;
		else
			hitNote = false;
			cameraShake('game', 0, 0.0001);
		end
	end
	
	if checkHold then
		tordHold = tordHold + e;
		if tordHold >= (stepCrochet / 2000) then
			tordHold = 0;
			checkHold = false;
			playAnim('dad', singTable[lastDir + 1], true);
			setProperty('dad.holdTimer', 0);
		end
	end
end

isPressing = false;
function buttonPressTord(n)
	setObjAlpha('tord-buttonPress', 1);
	setObjAlpha('tord', 0);
	
	playAnim('tord-buttonPress', n, true);
end

lastDir = 0;
checkHold = false;
tordHold = 0;
tordHTimer = 0;
hitNote = false;
danceNoteHit = false;
function opponentNoteHit(i, d, n, s)
	if dadName == 'tord' then
		tordHTimer = 37;
		hitNote = true;
		if s then
			checkHold = true;
			tordHold = 0;
			lastDir = d;
		else
			if getHealth() > 0.01 then
				addHealth((-((getRandomInt(2, 3) * 2) / 100)) * (0.023 / 0.06));
			end
		end
		if danceNoteHit then 
			setProperty('dad.skipDance', false);
			danceNoteHit = false;
		end
	end
end

function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Prepare Tord'] = function()
		runHaxeFunction('setTordDad');
		setObjectOrder('dadGroup', getObjectOrder('tord') - 1);
	end,
	['TordBot Zoom'] = function(v1)
		if v1 == '0' then
			scaleObject('tordGlass', 5, 5, false);
	
			startTween('faceZoomOut', 'tordGlass.scale', {x = 2, y = 2}, 0.2 / playbackRate, {ease = 'quadIn'});
			doTweenAlpha('faceOutAlpha', 'tordGlass', 1, 0.2125 / playbackRate);
		end
	end,
	['Tord Ha'] = function()
		playAnim('dad', 'hey', true);
	end,
	['Tord Play Anim'] = function(v1)
		if v1 == '' then
			setProperty('dad.skipDance', false);
			characterDance('dad');
		else
			playAnim('dad', v1, true);
			if tordAnimFuncs[v1] then tordAnimFuncs[v1](); end
		end
	end,
	['Tord Ending'] = function(v1)
		setObjAlpha('tord', 0);
		setObjAlpha('tord-ending', 1);
		
		playAnim('tord-ending', v1, true);
		alertColor = true;
	end
}

tordAnimFuncs = {
	['pissed'] = function()
		danceNoteHit = true;
		setProperty('dad.skipDance', true);
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['camIntoTord'] = function()
		setObjAlpha('tord', 1);
		setObjAlpha('tordBG', 1);
		
		setObjAlpha('tordGlass', 1);
		doTweenAlpha('tordGlassFade', 'tordGlass', 5 / 255, 0.53125 / playbackRate);
		scalingGlassTord = true;
	end,
	['tordGlassFade'] = function()
		setObjAlpha('tordGlass', 0);
		scalingGlassTord = false;
	end,
	['tordOutOfPit'] = function()
		cancelTween('faceOutAlpha');
		cancelTween('faceZoomOut');
		
		setObjAlpha('tordGlass', 0);
		setObjAlpha('tord', 0);
		setObjAlpha('tord-ending', 0);
		setObjAlpha('tordBG', 0);
		
		alertColor = false;
	end
}

function math.lerp(a, b, ratio) return a + ratio * (b - a); end

function RGBToHex(t)
    return tonumber(string.format('0x00%.2x%.2x%.2x', t[1], t[2], t[3])); 
end
