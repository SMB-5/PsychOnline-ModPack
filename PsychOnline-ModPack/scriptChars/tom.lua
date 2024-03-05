upScale = 1 / 0.7;
tomScale = upScale * 1.15;
tomX = 0;
function onCreate()
	luaDebugMode = true;
	
	tomX = 651 * upScale;
	makeAnimatedLuaSprite('tom', 'eddsworld/bgchars/tom', tomX, 495 * upScale);
	addAnimationByPrefix('tom', 'walk', 'walk', 10);
	addAnimationByPrefix('tom', 'transition', 'tomTransition', 9, false);
	addAnimationByPrefix('tom', 'idle', 'idle', 11);
	addAnimationByPrefix('tom', 'turn', 'tomTurns', 20, false);
	addAnimationByIndices('tom', 'turnBack', 'tomTurns', '8,7,6,5,4,3,2,1', 20);
	addAnimationByPrefix('tom', 'idle-alt', 'tomLooking', 11);
	addAnimationByPrefix('tom', 'reaction', 'tomSurprise', 14);
	scaleObject('tom', tomScale, tomScale);
	local tomCen = getObjCen('tom');
	offsetFrameRate('tom', 'walk', tomCen[1] + m1(79), tomCen[2] + m1(320), 10.2);
	offsetFrameRate('tom', 'transition', tomCen[1] + m1(71), tomCen[2] + m1(311), 10.2);
	offsetFrameRate('tom', 'idle', tomCen[1] + m1(71), tomCen[2] + m1(311), 11.4);
	offsetFrameRate('tom', 'turn', tomCen[1] + m1(71), tomCen[2] + m1(311), 20.4);
	offsetFrameRate('tom', 'turnBack', tomCen[1] + m1(71), tomCen[2] + m1(311), 20.4);
	offsetFrameRate('tom', 'idle-alt', tomCen[1] + m1(71), tomCen[2] + m1(311), 11.4);
	offsetFrameRate('tom', 'reaction', tomCen[1] + m1(70), tomCen[2] + m1(314), 11.4);
	setLoopPoint('tom', 'idle', 3);
	setLoopPoint('tom', 'idle-alt', 4);
	setLoopPoint('tom', 'reaction', 1);
	playAnim('tom', 'walk', true);
	addLuaSprite('tom');
	setObjAlpha('tom', 0.00001);
	
	runHaxeCode("game.modchartSprites.get('tom').animation.finishCallback = function(n) parentLua.call('onTomAnimFin', [n]);");
end

function onTomAnimFin(n)
	if finAnims[n] then finAnims[n](); end
end

finAnims = {
	['transition'] = function()
		tomCanIdle = true;
		tomDance();
	end,
	['turn'] = function()
		tomSuff = '-alt';
		tomCanIdle = true;
		tomDance();
	end,
	['turnBack'] = function()
		tomSuff = '';
		tomCanIdle = true;
		tomDance();
	end
}

function onSongStart()
	setObjAlpha('tom', 0);
end

tomCanIdle = false;
tomSuff = '';
function onBeatHit()
	if curBeat % 2 == 0 then
		tomDance();
	end
end

function tomDance()
	if tomCanIdle then
		playAnim('tom', 'idle' .. tomSuff, true);
	end
end

autoAlt = false;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if doWalk and not inGameOver then
		local walkAmount = (2 * upScale) * (e / 0.01);
		tomX = tomX + walkAmount;
		if tomX >= 1086 * upScale then
			tomX = 1086 * upScale;
			
			doWalk = false;
			
			playAnim('tom', 'transition', true);
		end
		setObjX('tom', tomX);
	end
end

lastT = 'boyfriend'
function onMoveCamera(t)
	if lastT ~= t then
		if autoAlt and tomCanIdle then
			tomAlt((t ~= 'boyfriend'));
		end
		lastT = t;
	end
end

isAlting = false;
function tomAlt(i)
	if (i and not isAlting) or (not i and isAlting) then
		tomCanIdle = false;
		playAnim('tom', 'turn' .. (not i and 'Back' or ''), true);
		isAlting = i;
	end
end

doWalk = false;
function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Tom Out'] = function()
		setObjAlpha('tom', 1);
		playAnim('tom', 'walk', true);
		
		doWalk = true;
		autoAlt = true;
	end,
	['Eduardo Reaction'] = function()
		playAnim('tom', 'reaction', true);
		
		tomCanIdle = false;
	end,
	['BG Chars Return'] = function()
		playAnim('tom', 'turnBack', true);
		
		tomSuff = '';
		autoAlt = false;
	end,
	['Focus Char'] = function(v1)
		if not autoAlt then
			tomAlt((v1 ~= ''));
		end
	end
}

function offsetFrameRate(o, a, x, y, f)
	setObjFrameRate(o, a, f);
	addOffset(o, a, x, y);
end

function m1(n)
	return math.floor(n * 1.15) * upScale;
end
