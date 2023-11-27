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
	[8] = function()
		doTweenAlpha('halloweenBGTween', 'halloweenBG', 0.3, 0.71, 'sineOut')
		doTweenZoom('camGameTween', 'camGame', defaultCameraZooming + 0.2, 0.5, 'sineOut')
	end,
	[15] = function()
		doTweenAlpha('halloweenBGTween', 'halloweenBG', 0, 0.36, 'sineOut')
		doTweenZoom('camGameTween', 'camGame', defaultCameraZooming + 0.4, 0.5, 'sineOut')
	end,
	[16] = function()
		doTweenAlpha('halloweenBGTween', 'halloweenBG', 1, 0.36, 'sineOut')
		setProperty('defaultCamZoom', defaultCameraZooming)
		doTweenZoom('camGameTween', 'camGame', defaultCameraZooming, 0.5, 'linear')
	end,
	[48] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[54] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[56] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[62] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[64] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[70] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[72] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[78] = function()
		setProperty('defaultCamZoom', defaultCameraZooming)
	end,
	[112] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[118] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[120] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[126] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[128] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[134] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[136] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[142] = function()
		doTweenAlpha('halloweenBGTween', 'halloweenBG', 0.3, 0.71, 'sineOut')
		setProperty('defaultCamZoom', defaultCameraZooming)
	end,
	[144] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[188] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[192] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[204] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[208] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[220] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[224] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[236] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[240] = function()
		doTweenAlpha('halloweenBGTween', 'halloweenBG', 1, 0.36, 'sineOut')
		setProperty('defaultCamZoom', defaultCameraZooming)
	end
}