upScale = 1 / 0.7;
function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Pan Chump Car Ending'] = function()
		local panX = getProperty('carEvil.x') + (573 * upScale) + ((screenWidth / 2) * upScale);
		local panY = -165 * upScale;
		
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', panX);
		setProperty('camFollow.y', panY);
		
		startTween('camTankEndingPos', 'camGame.scroll', {x = panX - (screenWidth / 2), y = panY - (screenHeight / 2)}, 0.677 / playbackRate, {ease = 'quadOut'});
	end
}
