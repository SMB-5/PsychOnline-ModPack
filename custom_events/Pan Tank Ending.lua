upScale = 1 / 0.7;
function onEvent(n)
	if events[n] then events[n](); end
end

isFirstTime = true;
events = {
	['Pan Tank Ending'] = function()
		local panX = getProperty('tank.x') + (-423 * upScale) + ((screenWidth / 2) * upScale);
		local panY = 42 * upScale;
		local daTime = (isFirstTime and 1 or 2) / playbackRate;
		local daTween = (isFirstTime and 'quadOut' or 'quadInOut');
		
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', panX);
		setProperty('camFollow.y', panY);
		
		startTween('camTankEndingPos', 'camGame.scroll', {x = panX - (screenWidth / 2), y = panY - (screenHeight / 2)}, daTime, {ease = daTween});
		
		if isFirstTime then isFirstTime = false; end
	end
}
