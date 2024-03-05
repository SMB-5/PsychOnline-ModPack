upScale = 1 / 0.7;
function onCreate()
	makeAnimatedLuaSprite('jon', 'characters/eduardo/jon', 0, 510 * upScale);
	addAnimationByPrefix('jon', 'idle', 'JonIdle', 12, false);
	scaleObject('jon', upScale * 0.9347826, upScale * 0.94823529);
	local jonCen = getObjCen('jon');
	addOffset('jon', 'idle', jonCen[1] + (107 * upScale), jonCen[2] + (402 * upScale));
	playAnim('jon', 'idle', true);
	setObjAlpha('jon', 0.00001);
	setObjectOrder('jon', getObjectOrder('fence') - 1);
	
	makeAnimatedLuaSprite('mark', 'characters/eduardo/mark', 0, 500 * upScale);
	addAnimationByPrefix('mark', 'idle', 'MarkIdle', 12, false);
	scaleObject('mark', upScale * 0.78854625, upScale * 0.79697624);
	local markCen = getObjCen('mark');
	addOffset('mark', 'idle', markCen[1] + (89 * upScale), markCen[2] + (368 * upScale));
	playAnim('mark', 'idle', true);
	setObjAlpha('mark', 0.00001);
	setObjectOrder('mark', getObjectOrder('jon'));
end

function onSongStart()
	setObjAlpha('jon', 0);
	setObjAlpha('mark', 0);
end

canIdle = false;
function onBeatHit()
	if canIdle and curBeat % 2 == 0 then
		playAnim('jon', 'idle', true);
		playAnim('mark', 'idle', true);
	end
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Prepare Trio'] = function()
		canIdle = true;
		
		setObjX('mark', -271 * upScale);
		setObjX('jon', -367 * upScale);
		
		setObjAlpha('mark', 1);
		setObjAlpha('jon', 1);
	end,
	['Eduardo Punch'] = function()
		canIdle = false;
		
		removeLuaSprite('jon');
		removeLuaSprite('mark');
	end
}
