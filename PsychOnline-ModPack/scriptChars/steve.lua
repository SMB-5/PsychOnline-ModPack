upScale = 1 / 0.7;
function onCreate()
	makeAnimatedLuaSprite('tankSteve', 'characters/steve/steve', 0, 0);
	addAnimationByPrefix('tankSteve', 'idle', 'SteveIdle', 15, false);
	scaleObject('tankSteve', 0.9156627 * upScale, 0.9186992 * upScale);
	playAnim('tankSteve', 'idle', true);
	setObjectOrder('tankSteve', getObjectOrder('tank'));
	setProperty('tankSteve.alpha', 0.00001);
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('tankSteve', 'idle', true);
	end
end
