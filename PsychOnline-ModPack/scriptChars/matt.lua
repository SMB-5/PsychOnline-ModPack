upScale = 1 / 0.7;
mattScale = upScale * 1.15;
mattCen = {};
allSpr = {};
function onCreate()
	luaDebugMode = true;
	
	makeAnimatedLuaSprite('matt', 'eddsworld/bgchars/matt/matt', 625 * upScale, 495 * upScale);
	addAnimationByPrefix('matt', 'walk', 'walk', 11);
	addAnimationByIndices('matt', 'transition', 'idle', '3,4,5', 11);
	addAnimationByPrefix('matt', 'idle', 'idle', 11, false);
	setObjFrameRate('matt', 'walk', 10.8);
	setObjFrameRate('matt', 'transition', 11.4);
	setObjFrameRate('matt', 'idle', 11.4);
	scaleObject('matt', mattScale, mattScale);
	mattCen = getObjCen('matt');
	addOffset('matt', 'walk', mattCen[1] + m1(82), mattCen[2] + m1(320));
	addOffset('matt', 'transition', mattCen[1] + m1(141), mattCen[2] + m1(328));
	addOffset('matt', 'idle', mattCen[1] + m1(141), mattCen[2] + m1(328));
	playAnim('matt', 'walk', true);
	addLuaSprite('matt');
	setObjAlpha('matt', 0.00001);
	
	table.insert(allSpr, 'matt');
end

function loadBores()
	makeAnimatedLuaSprite('mattEduardo', 'eddsworld/bgchars/matt/matt-eduardo', 140 * upScale, 495 * upScale);
	addAnimationByPrefix('mattEduardo', 'reaction', 'reaction', 14, false);
	addAnimationByPrefix('mattEduardo', 'idle', 'mattPISSED', 11, false);
	setObjFrameRate('mattEduardo', 'reaction', 14.4);
	setObjFrameRate('mattEduardo', 'idle', 11.4);
	scaleObject('mattEduardo', mattScale, mattScale);
	addOffset('mattEduardo', 'reaction', mattCen[1] + m1(100), mattCen[2] + m1(330));
	addOffset('mattEduardo', 'idle', mattCen[1] + m1(141), mattCen[2] + m1(328));
	playAnim('mattEduardo', 'reaction', true);
	setObjectOrder('mattEduardo', getObjectOrder('matt'));
	setObjAlpha('mattEduardo', 0.00001);
	
	table.insert(allSpr, 'mattEduardo');
end

function loadMix()
	makeAnimatedLuaSprite('mattTord', 'eddsworld/bgchars/matt/matt-tord', 140 * upScale, 495 * upScale);
	addAnimationByPrefix('mattTord', 'reaction', 'mattReactionTord', 19, false);
	addAnimationByPrefix('mattTord', 'endingLook', 'mattLookUp', 12);
	addAnimationByPrefix('mattTord', 'endingPhew', 'mattHarpoonBit', 9);
	setObjFrameRate('mattTord', 'reaction', 19.2);
	setLoopPoint('mattTord', 'endingPhew', 3);
	scaleObject('mattTord', mattScale, mattScale);
	addOffset('mattTord', 'reaction', mattCen[1] + m1(109), mattCen[2] + m1(330));
	addOffset('mattTord', 'endingLook', mattCen[1] + m1(105), mattCen[2] + m1(316));
	addOffset('mattTord', 'endingPhew', mattCen[1] + m1(105), mattCen[2] + m1(316));
	playAnim('mattTord', 'reaction', true);
	setObjectOrder('mattTord', getObjectOrder('matt'));
	setProperty('mattTord.alpha', 0.00001);
	
	table.insert(allSpr, 'mattTord');
end

function onSongStart()
	for i = 1, #allSpr do
		setObjAlpha(allSpr[i], 0);
	end
	allSpr = nil;
end

mattCanIdle = false;
function onBeatHit()
	if curBeat % 2 == 0 then
		mattDance();
	end
end

function mattDance()
	if mattCanIdle then
		playAnim((usingESprites and 'mattEduardo' or 'matt'), 'idle', true);
	end
end

doWalk = false;
usingESprites = false;
usingTSprites = false;
function onEvent(n, v1)
	if events[n] then events[n](v1) end
end

events = {
	['Matt Out'] = function()
		doWalk = true;
		setObjAlpha('matt', 1);
		playAnim('matt', 'walk', true);
	end,
	['Eduardo Reaction'] = function()
		usingESprites = true;
		mattCanIdle = false;
		
		playAnim('mattEduardo', 'reaction', true);
		
		if not doWalk then
			setObjAlpha('matt', 0);
			setObjAlpha('mattEduardo', 1);
		end
	end,
	['BG Chars Return'] = function()
		mattCanIdle = true;
	end,
	['Tord Scare'] = function()
		usingTSprites = true;
		mattCanIdle = false;
		
		playAnim('mattTord', 'reaction', true);
		
		if not doWalk then
			setObjAlpha('matt', 0);
			setObjAlpha('mattTord', 1);
		end
	end,
	['Prepare Ending'] = function()
		mattCanIdle = false;
		playAnim('mattTord', 'endingLook', true);
	end,
	['Tom Talk'] = function(v1)
		if v1 == '0' then playAnim('mattTord', 'endingPhew', true); end
	end
}

mattX = 625 * upScale;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if doWalk and not inGameOver then
		local walkAmount = (3 * upScale) * (e / 0.01);
		mattX = mattX - walkAmount;
		if mattX <= (140 * upScale) then
			mattX = 140 * upScale;
			doWalk = false;
			
			if not usingESprites and not usingTSprites then
				mattCanIdle = true;
				
				playAnim('matt', 'transition', true);
			else
				setObjAlpha('matt', 0);
				setProperty((usingESprites and 'mattEduardo' or 'mattTord') .. '.alpha', 1);
			end
		end
		setObjX('matt', mattX);
	end
end

function m1(n)
	return math.floor(n * 1.15) * upScale;
end
