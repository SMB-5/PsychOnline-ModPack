upScale = 1 / 0.7;
eddScale = 0.70822281 * upScale * 1.03;
dadPos = {};
allSpr = {};
function onCreate()
	luaDebugMode = true;
	scaleObject('dad', eddScale, eddScale);
	resizeOffsets('dad', eddScale);
	
	runHaxeCode([[
		function loadBFOld() {
			setVar('oldBoyf', game.boyfriend);
		}
		
		function beatHitBores() {
			var oldBoyf = getVar('oldBoyf');
			var eddFacing = getVar('eddFaces');
			
			if (!oldBoyf.isPlayer && oldBoyf.animation.curAnim != null && !oldBoyf.stunned && game.curBeat % oldBoyf.danceEveryNumBeats == 0 && 
				!StringTools.startsWith(oldBoyf.animation.curAnim.name, 'sing')) 
				oldBoyf.dance();
				
			if (!eddFacing.isPlayer && eddFacing.animation.curAnim != null && !eddFacing.stunned && game.curBeat % eddFacing.danceEveryNumBeats == 0 && 
				!StringTools.startsWith(eddFacing.animation.curAnim.name, 'sing'))
				eddFacing.dance(); 
		}
		
		function switchBf(t:String) {
			var newChar = getVar(t);
			newChar.isPlayer = true;
			
			game.boyfriend.isPlayer = false;
			game.boyfriend = newChar;
			
			game.setOnLuas('boyfriendName', game.boyfriend.curCharacter);
		}
	]]);
	
	dadPos = getObjPos('dad');
end

function onCreatePost()
	runHaxeFunction('loadBFOld');
end

bfDeathJson = '';
function onSongStart()
	bfDeathJson = getPropertyFromClass('substates.GameOverSubstate', 'characterName');
	
	for i = 1, #allSpr do
		setObjAlpha(allSpr[i], 0);
	end
	allSpr = nil;
end

boring = false;
function loadBores()
	createInstance('eddFaces', 'objects.Character', {dadPos[1], dadPos[2], 'edd-side'});
	scaleObject('eddFaces', eddScale, eddScale);
	setObjFrameRate('eddFaces', 'turn', 19.2);
	setObjFrameRate('eddFaces', 'turn-loop', 19.2);
	resizeOffsets('eddFaces', eddScale);
	setObjectOrder('eddFaces', getObjectOrder('boyfriendGroup') + 1);
	setProperty('eddFaces.alpha', 0.00001);
	setProperty('eddFaces.isPlayer', true);
	
	loadedd = 'eddFaces';
	table.insert(allSpr, 'eddFaces');
end

function loadMix()
	createInstance('comicEdd', 'objects.Character', {-224 - 65, -437 + 1233, 'edd-slide'});
	setScrollFactor('comicEdd');
	setObjectOrder('comicEdd', 99999);
	setProperty('comicEdd.skipDance', true);
	setObjAlpha('comicEdd', 0.00001);
	
	singTable = getProperty('singAnimations');
	
	loadedd = 'comicEdd';
	
	makeAnimatedLuaSprite('eddTord', 'characters/edd/edd-tord', dadPos[1], dadPos[2]);
	addAnimationByPrefix('eddTord', 'react', 'EddGroundShaking', 14);
	addAnimationByPrefix('eddTord', 'tordLook', 'EddTurnToTord', 14);
	addAnimationByIndices('eddTord', 'endingLook', 'EddLookingUp', '0,1', 12, true);
	addAnimationByIndices('eddTord', 'lookAtTom', 'EddLookingUp', '2,3,4,5', 11, true);
	setObjFrameRate('eddTord', 'react', 14.4);
	setObjFrameRate('eddTord', 'tordLook', 14.4);
	setObjFrameRate('eddTord', 'lookAtTom', 10.8);
	setLoopPoint('eddTord', 'react', 3);
	setLoopPoint('eddTord', 'tordLook', 3);
	setLoopPoint('eddTord', 'lookAtTom', 2);
	scaleObject('eddTord', eddScale, eddScale);
	addOffset('eddTord', 'react', 87 * eddScale, -7 * eddScale);
	addOffset('eddTord', 'tordLook', 90 * eddScale, -37 * eddScale);
	addOffset('eddTord', 'endingLook', -55 * eddScale, 2 * eddScale);
	addOffset('eddTord', 'lookAtTom', -55 * eddScale, 2 * eddScale);
	playAnim('eddTord', 'react', true);
	setObjectOrder('eddTord', getObjectOrder('dadGroup') + 1);
	setObjAlpha('eddTord', 0.00001);
	
	table.insert(allSpr, 'comicEdd');
	table.insert(allSpr, 'eddTord');
end

function onBeatHit()
	if boring then runHaxeFunction('beatHitBores'); end
end

function onUpdatePost(e)
	e = e * playbackRate;
	if checkHold then
		eddHold = eddHold + e;
		if eddHold >= (stepCrochet / 2000) then
			eddHold = 0;
			checkHold = false;
			playAnim('comicEdd', singTable[lastDir + 1], true);
		end
	end
end

siding = false;
loadedd = '';
function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Show Eddside'] = function()
		setObjAlpha('dad', 0);
		setObjAlpha('eddFaces', 1);
		
		playAnim('eddFaces', 'turn', true);
		setProperty('eddFaces.skipDance', true);
		isSkipping = true;
		
		boring = true;
	end,
	['Switch Player Singer'] = function()
		siding = not siding;
		runHaxeFunction('switchBf', {(siding and loadedd or 'oldBoyf')});
		setPropertyFromClass('substates.GameOverSubstate', 'characterName', (siding and 'edd-gameover' or bfDeathJson));
	end,
	['Tord Scare'] = function()
		setObjAlpha('dad', 0);
		setObjAlpha('eddTord', 1);
		
		playAnim('eddTord', 'react', true);
	end,
	['Edd Bf Turn'] = function()
		playAnim('eddTord', 'tordLook', true);
	end,
	['Hide BF Edd Comic'] = function()
		eddComicShow(false);
	end,
	['Prepare Ending'] = function()
		playAnim('eddTord', 'endingLook', true);
	end,
	['Tom Talk'] = function(v1)
		if v1 == '1' then playAnim('eddTord', 'lookAtTom', true); end
	end
}

lastDir = 0;
lastNotePress = 0;
eddHold = 0;
checkHold = false;
function goodNoteHit(i, d, n, s)
	if siding and isSkipping then
		isSkipping = false;
		setProperty('boyfriend.skipDance', false);
	end
	if boyfriendName == 'edd-slide' and n == '' then
		if s then
			lastDir = d;
			eddHold = 0;
			checkHold = true;
		else
			eddComicShow(true);
			lastNotePress = getSongPosition() / 1000;
		end
	end
end

idleTime = 9;
function opponentNoteHit(i, d, n, s)
	if not s and hasEntered then
		local idleChange = (idleTime - ((((getSongPosition() / 1000) - lastNotePress) / 0.01) * 1.3));
		if idleChange <= 0 then
			eddComicShow(false);
		end
	end
end

hasEntered = false;
function eddComicShow(show)
	if (show and not hasEntered) or (not show and hasEntered) then
		hasEntered = show;
		cancelTween('edd' .. (show and 'Exit' or 'Enter'));
		startTween('edd' .. (show and 'Enter' or 'Exit'), 'comicEdd', {
			x = ((show and (-20 - 65) or (-224 - 65))),
			y = (-437 + (show and (792 + 33) or 1233))
		}, (show and 0.2 or 0.46) / playbackRate, {
			ease = 'quad' .. (show and 'out' or 'in'),
			onComplete = 'onTweenCompleted'
		});
		
		if show then setObjAlpha('comicEdd', 1); end
	end
end

function onGameOver()
	if boyfriendName == 'edd-slide' then
		setObjPos('boyfriend', dadPos[1] - getProperty('camGame.scroll.x'), dadPos[2] - getProperty('camGame.scroll.y'));
	end
end

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['eddExit'] = function()
		setObjAlpha('comicEdd', 0);
	end
}
