upScale = 1 / 0.7;
function onCreate()
	local eyeScale = 1.11590296 * upScale;
	makeAnimatedLuaSprite('eyeFall', 'fx/fucked/ROBOT EYE', 0, 579 * upScale);
	addAnimationByPrefix('eyeFall', 'fall', 'ROBOTEYEFALLSBACK', 28);
	scaleObject('eyeFall', eyeScale, eyeScale);
	local cen = getObjCen('eyeFall');
	addOffset('eyeFall', 'fall', cen[1] + (207 * upScale), cen[2] + (797 * upScale));
	setObjFrameRate('eyeFall', 'fall', 28.8);
	setLoopPoint('eyeFall', 'fall', 9);
	playAnim('eyeFall', 'fall', true);
	setObjectOrder('eyeFall', getObjectOrder('gfGroup') + 1);
	setObjAlpha('eyeFall', 0.00001);
end

function destroyCache()
	setObjAlpha('eyeFall', 0);
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Robot Eye Fall'] = function()
		setObjectOrder('eyeFall', getObjectOrder('dadGroup') + 1);
		setObjX('eyeFall', getRobotXProper() - (210 * upScale));
		setObjAlpha('eyeFall', 1);
		playAnim('eyeFall', 'fall', true);
	end
}
