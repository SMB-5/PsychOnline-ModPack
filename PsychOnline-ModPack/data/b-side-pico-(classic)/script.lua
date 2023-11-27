local stageAssets ={
	'bg',
	'city',
	'streetBehind',
	'phillyTrain',
	'phillyStreet'
}

local defaultCameraZooming = 0

function onCreatePost()
	defaultCameraZooming = getProperty('defaultCamZoom')
end

function onSongStart()
	for index, value in ipairs(stageAssets) do
		doTweenColor(value .. 'Tween', value, '000000', 2.94, 'sineOut')
	end
	doTweenZoom('camGameTween', 'camGame', defaultCameraZooming + 0.2, 2.95, 'sineOut')
	setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
end

function onBeatHit()
	if beatHitFuncs[curBeat] then 
		beatHitFuncs[curBeat]()
	end
end

beatHitFuncs = {
	[38] = function()
		for index, value in ipairs(stageAssets) do
			doTweenColor(value .. 'Tween', value, 'FFFFFF', 0.74, 'sineOut')
		end
		doTweenZoom('camGameTween', 'camGame', defaultCameraZooming - 0.1, 0.74, 'sineOut')
		setProperty('defaultCamZoom', defaultCameraZooming)
	end,
	[72] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[108] = function()
		for index, value in ipairs(stageAssets) do
			doTweenColor(value .. 'Tween', value, '000000', 1.47, 'sineOut')
		end
		doTweenZoom('camGameTween', 'camGame', defaultCameraZooming + 0.4, 1.47, 'sineOut')
		setProperty('defaultCamZoom', defaultCameraZooming)
	end,
	[112] = function()
		for index, value in ipairs(stageAssets) do
			doTweenColor(value .. 'Tween', value, 'FFFFFF', 0.37, 'sineOut')
		end
	end,
	[136] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[144] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[152] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.3)
	end,
	[160] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.4)
	end,
	[168] = function()
		setProperty('defaultCamZoom', defaultCameraZooming)
	end
}