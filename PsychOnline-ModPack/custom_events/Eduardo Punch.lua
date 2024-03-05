function onCreatePost()
	upScale = 1 / 0.7;
	punchScale = upScale * 1.03;
	makeAnimatedLuaSprite('eduardoPunch', 'characters/eduardo/EduardoPunch', 0, ((548 + 3) * upScale));
	addAnimationByPrefix('eduardoPunch', 'woosh', 'Woosh', 14, false);
	addAnimationByPrefix('eduardoPunch', 'punch', 'Punch', 13, false);
	addAnimationByPrefix('eduardoPunch', 'a', 'A');
	addAnimationByPrefix('eduardoPunch', 'ow', 'OW', 14, false);
	addAnimationByPrefix('eduardoPunch', 'even', 'Even', 17, false);
	addAnimationByPrefix('eduardoPunch', 'say', 'Say', 5, false);
	addAnimationByPrefix('eduardoPunch', 'shutUp', 'ShutUp', 28, false);
	scaleObject('eduardoPunch', punchScale, punchScale);
	local eduardoPCen = getObjCen('eduardoPunch');
	local eduOff = {eduardoPCen[1] + (math.floor(212 * 1.03) * upScale), eduardoPCen[2] + (math.floor(491 * 1.03) * upScale)};
	offsetFrameRate('eduardoPunch', 'woosh', eduOff[1], eduOff[2], 14.4);
	offsetFrameRate('eduardoPunch', 'punch', eduOff[1], eduOff[2], 13.2);
	offsetFrameRate('eduardoPunch', 'ow', eduOff[1], eduOff[2], 14.4);
	offsetFrameRate('eduardoPunch', 'even', eduOff[1], eduOff[2], 16.2);
	offsetFrameRate('eduardoPunch', 'say', eduOff[1], eduOff[2], 5.4);
	offsetFrameRate('eduardoPunch', 'shutUp', eduOff[1], eduOff[2], 27.6);
	addOffset('eduardoPunch', 'a', eduOff[1], eduOff[2]);
	playAnim('eduardoPunch', 'woosh', true);
	setObjectOrder('eduardoPunch', getObjectOrder('fence') - 1);
	setObjAlpha('eduardoPunch', 0.00001);
end

function onSongStart()
	setObjAlpha('eduardoPunch', 0);
end

firstPunch = false;
function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Eduardo Punch'] = function(v1)
		if not firstPunch then
			firstPunch = true;
			setObjAlpha('dad', 0);
			setObjAlpha('eduardoPunch', 1);
			setObjX('eduardoPunch', (-475 + 93) * upScale);
		end
		playAnim('eduardoPunch', v1, true);
	end
}

function offsetFrameRate(o, a, x, y, f)
	setObjFrameRate(o, a, f);
	addOffset(o, a, x, y);
end