local defaultCameraZooming = 0

function onCreatePost()
	defaultCameraZooming = getProperty('defaultCamZoom')
end

function onBeatHit()
	if beatHitFuncs[curBeat] then 
		beatHitFuncs[curBeat]()
	end
end

beatHitFuncs = {
	[32] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[60] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.3)
	end,
	[64] = function()
		doTweenAlpha('halloweenBGTween', 'halloweenBG', 0.5, 0.65, 'sineOut')
		setProperty('defaultCamZoom', defaultCameraZooming)
	end,
	[128] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[160] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[190] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.3)
	end,
	[192] = function()
		setProperty('defaultCamZoom', defaultCameraZooming)
	end,
	[260] = function()
		doTweenAlpha('halloweenBGTween', 'halloweenBG', 0, 1.30, 'sineOut')
		doTweenAlpha('gameCameraTween', 'camGame', 0, 1.30, 'sineOut')
	end
}

function onSongStart()
	doTweenAlpha('halloweenBGTween', 'halloweenBG', 0.3, 2.61, 'sineOut')
end