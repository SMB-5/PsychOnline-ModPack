upScale = 1 / 0.7;
function onCreatePost()
	makeAnimatedLuaSprite('tomRun', 'eddsworld/end mix/tom/tomRunsIn', 1091 * upScale, 726 * upScale);
	addAnimationByPrefix('tomRun', 'runIn', 'Tom Running In', 10, false);
	scaleObject('tomRun', upScale * 1.2, upScale * 1.2);
	local tomCen = getObjCen('tomRun');
	addOffset('tomRun', 'runIn', tomCen[1] + (math.floor(213 * 1.2) * upScale), tomCen[2] + (math.floor(472 * 1.2) * upScale));
	setObjFrameRate('tomRun', 'runIn', 10.2);
	playAnim('tomRun', 'runIn', true);
	addLuaSprite('tomRun', true);
	setObjectOrder('tomRun', getObjectOrder('boyfriendGroup') + 3);
	setObjAlpha('tomRun', 0.00001);
end

function onSongStart()
	setObjAlpha('tomRun', 0);
end

passedTime = 0;
spawnTom = false;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if spawnTom then
		passedTime = passedTime + e;
		if passedTime >= 0.06 then
			setObjAlpha('tomRun', 1);
			spawnTom = false;
		end
	end
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Tom Running In'] = function()
		playAnim('tomRun', 'runIn', true);
		spawnTom = true;
	end,
	['Prepare Ending'] = function()
		removeLuaSprite('tomRun');
	end
}
