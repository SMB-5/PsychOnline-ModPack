upScale = 1 / 0.7;
bfPos = {}
function onCreate()
	luaDebugMode = true
	
	createInstance('comicBF', 'objects.Character', {-519 + 1646, -512 + 1200, 'bf-slide'});
	setScrollFactor('comicBF');
	setObjectOrder('comicBF', 99999);
	setProperty('comicBF.skipDance', true);
	setObjAlpha('comicBF', 0.00001);
	
	runHaxeCode([[
		function bfSwitchFucked() {
			setVar('originalBF', game.boyfriend); //just in case
			
			setVar('oldBoyf', getVar('comicBF'));
			game.boyfriend = getVar('comicBF');
			game.setOnLuas('boyfriendName', game.boyfriend.curCharacter);
		}
	]]);
	
	bfPos = getObjPos('boyfriend');
	
	makeAnimatedLuaSprite('bfTord', 'characters/boyfriend/bf-tord', bfPos[1], bfPos[2]);
	addAnimationByPrefix('bfTord', 'react', 'BF Ground Shaking', 11, false);
	addAnimationByPrefix('bfTord', 'tordLook', 'BF Look At Tord', 11, false);
	setObjFrameRate('bfTord', 'react', 10.8);
	setObjFrameRate('bfTord', 'tordLook', 11.4);
	addOffset('bfTord', 'react', -2, -8);
	addOffset('bfTord', 'tordLook', -10, -1);
	playAnim('bfTord', 'react', true);
	setObjectOrder('bfTord', getObjectOrder('boyfriendGroup'));
	setObjAlpha('bfTord', 0.00001);
	
	local lookScale = 0.64358974 * upScale * 1.12;
	makeLuaSprite('bfLooks', 'characters/boyfriend/bf-lookup', (979 - math.floor(104 * 1.12)) * upScale, (597 - math.floor(265 * 1.12)) * upScale);
	scaleObject('bfLooks', lookScale, lookScale);
	setObjectOrder('bfLooks', getObjectOrder('boyfriendGroup'));
	setObjAlpha('bfLooks', 0.00001);
	
	singTable = getProperty('singAnimations');
end

function onSongStart()
	setObjAlpha('comicBF', 0);
	setObjAlpha('bfTord', 0);
	setObjAlpha('bfLooks', 0);
end

singTable = {};
function onUpdatePost(e)
	e = e * playbackRate;
	if checkHold then
		bfHold = bfHold + e;
		if bfHold >= (stepCrochet / 2000) then
			bfHold = 0;
			checkHold = false;
			playAnim('comicBF', singTable[lastDir + 1], true);
		end
	end
end

tSeen = false;
function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Tord Scare'] = function()
		setObjAlpha('boyfriendGroup', 0);
		setObjAlpha('bfTord', 1);
		
		playAnim('bfTord', 'react', true);
		
		runHaxeFunction('bfSwitchFucked');
		setObjectOrder('boyfriendGroup', getObjectOrder('comicBF') - 1);
	end,
	['Edd Bf Turn'] = function()
		playAnim('bfTord', 'tordLook', true);
	end,
	['Hide BF Edd Comic'] = function()
		bfComicShow(false);
	end,
	['Prepare Ending'] = function()
		removeLuaSprite('bfTord');
		setObjAlpha('bfLooks', 1);
	end
}

lastDir = 0;
lastNotePress = 0;
bfHold = 0;
checkHold = false;
function goodNoteHit(i, d, n, s)
	if boyfriendName == 'bf-slide' and n == '' then
		if s then
			lastDir = d;
			bfHold = 0;
			checkHold = true;
		else
			bfComicShow(true);
			lastNotePress = getSongPosition() / 1000;
		end
	end
end

idleTime = 9;
function opponentNoteHit(i, d, n, s)
	if not s and hasEntered then
		local idleChange = (idleTime - ((((getSongPosition() / 1000) - lastNotePress) / 0.01) * 1.3));
		if idleChange <= 0 then
			bfComicShow(false);
		end
	end
end

hasEntered = false;
function bfComicShow(show)
	if (show and not hasEntered) or (not show and hasEntered) then
		hasEntered = show;
		cancelTween('bf' .. (show and 'Exit' or 'Enter'));
		startTween('bf' .. (show and 'Enter' or 'Exit'), 'comicBF', {
			x = (-519 + (show and 1352 or 1646)),
			y = (-512 + (show and 792 or 1200))
		}, (show and 0.2 or 0.46) / playbackRate, {
			ease = 'quad' .. (show and 'out' or 'in'),
			onComplete = 'onTweenCompleted'
		});
		
		if show then setObjAlpha('comicBF', 1); end
	end
end

function onGameOver()
	if boyfriendName == 'bf-slide' then
		setObjPos('boyfriend', bfPos[1] - getProperty('camGame.scroll.x'), bfPos[2] - getProperty('camGame.scroll.y'));
	end
end

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['bfExit'] = function()
		setObjAlpha('comicBF', 0);
	end
}
