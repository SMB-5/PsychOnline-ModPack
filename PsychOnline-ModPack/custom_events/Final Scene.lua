upScale = 1 / 0.7;
function onCreate()
	local punchScale = 1.16636197 * upScale;
	makeAnimatedLuaSprite('PUUNCH', 'characters/PUNCH', 574 * upScale, 349 * upScale);
	addAnimationByPrefix('PUUNCH', 'punch', 'FinalPunch', 14, false);
	scaleObject('PUUNCH', punchScale, punchScale);
	local punchCen = getObjCen('PUUNCH');
	addOffset('PUUNCH', 'punch', punchCen[1] + (318 * upScale), punchCen[2] + (272 * upScale));
	setObjFrameRate('PUUNCH', 'punch', 14.4);
	playAnim('PUUNCH', 'punch', true);
	setObjectOrder('PUUNCH', getObjectOrder('boyfriendGroup') + 1);
	setObjAlpha('PUUNCH', 0.00001);
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Final Scene'] = function()
		setObjAlpha('PUUNCH', 1);
		playAnim('PUUNCH', 'punch', true);
	end
}
