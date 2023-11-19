upScale = 1 / 0.7;
gfScale = 1.00429184 * upScale * 1.08;
function onCreatePost()
	makeAnimatedLuaSprite('gfHotdog', 'nevada/gfHotDog', 1500 * upScale, 396 * upScale);
	addAnimationByPrefix('gfHotdog', 'walk', 'GFStandingWithHotDogWalk', 29);
	addAnimationByPrefix('gfHotdog', 'danceLeft', 'GFStandingWithHotDogLeft', 29, false);
	addAnimationByPrefix('gfHotdog', 'danceRight', 'GFStandingWithHotDogRight', 30, false);
	scaleObject('gfHotdog', gfScale, gfScale);
	local gfCen = getObjCen('gfHotdog');
	addOffset('gfHotdog', 'walk', gfCen[1] + (math.floor(116 * 1.08) * upScale), gfCen[2] + (math.floor(153 * 1.08) * upScale));
	addOffset('gfHotdog', 'danceLeft', gfCen[1] + (math.floor(119 * 1.08) * upScale), gfCen[2] + (math.floor(162 * 1.08) * upScale));
	addOffset('gfHotdog', 'danceRight', gfCen[1] + (math.floor(119 * 1.08) * upScale), gfCen[2] + (math.floor(162 * 1.08) * upScale));
	playAnim('gfHotdog', 'walk', true);
	setObjFrameRate('gfHotdog', 'walk', 28.8);
	setObjFrameRate('gfHotdog', 'danceLeft', 28.8);
	setObjectOrder('gfHotdog', getObjectOrder('boyfriendGroup'));
	setObjAlpha('gfHotdog', 0.00001);
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['GF Hotdog Walk In'] = function()
		setObjAlpha('gfHotdog', 1);
		
		isWalking = true;
	end
}

isWalking = false;
function onUpdatePost(e)
	if not inGameOver then gfWalk(e); end
end

function gfWalk(e)
	if isWalking then
		addToX('gfHotdog', -5 * (e / 0.02) * upScale);
		
		if getObjPos('gfHotdog')[1] <= 1185 * upScale then
			setObjX('gfHotdog', 1185 * upScale);
			isWalking = false;
			
			canDance = true;
			gfDance();
		end
	end
end

function onBeatHit()
	danced = not danced;
	gfDance();
end

canDance = false;
danced = false;
function gfDance()
	if canDance then
		playAnim('gfHotdog', 'dance' .. (danced and 'Right' or 'Left'), true);
	end
end
