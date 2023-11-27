luaDebugMode = true

local characterPositions = {0, 0}
local defaultCameraZooming = 0
local trainFrameTiming = 0
local schmooving = false

function onCreatePost()
	makeLuaSprite('bgEffect', '', -200, -200)
	makeGraphic('bgEffect', 2000, 2000, 'FFFFFF')
	setScrollFactor('bgEffect', 0, 0)
	addLuaSprite('bgEffect', false)
	setProperty('bgEffect.alpha', 0)

	makeLuaSprite('groundTrain', 'philly/train', -400, 760)
	addLuaSprite('groundTrain', false)

	setProperty('groundTrain.color', 0x000000)
	setProperty('groundTrain.visible', false)

	characterPositions[1] = getProperty('boyfriend.y')
	characterPositions[2] = getProperty('dad.y')

	defaultCameraZooming = getProperty('defaultCamZoom')

	precacheImage('philly/longWindow', true)
end

function onBeatHit()
	if beatHitFuncs[curBeat] then 
		beatHitFuncs[curBeat]()
	end
end

beatHitFuncs = {
	[124] = function()
		doTweenZoom('tweenCameraIn', 'camGame', defaultCameraZooming + 0.1, 1.22, 'sineOut')
	end,
	[128] = function()
		toggleEvent()
	end,
	[144] = function()
		setProperty('defaultCamZoom', defaultCameraZooming - 0.1)
	end,
	[148] = function()
		setProperty('defaultCamZoom', defaultCameraZooming)
	end,
	[152] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[156] = function()
		setProperty('defaultCamZoom', defaultCameraZooming)
	end,
	[158] = function()
		setProperty('defaultCamZoom', defaultCameraZooming - 0.1)
	end,
	[159] = function()
		setProperty('defaultCamZoom', defaultCameraZooming - 0.3)
	end,
	[160] = function()
		setProperty('defaultCamZoom', defaultCameraZooming - 0.2)
	end,
	[176] = function()
		setProperty('defaultCamZoom', defaultCameraZooming - 0.1)
	end,
	[180] = function()
		setProperty('defaultCamZoom', defaultCameraZooming)
	end,
	[184] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.1)
	end,
	[188] = function()
		setProperty('defaultCamZoom', defaultCameraZooming + 0.2)
	end,
	[192] = function()
		toggleEvent()
	end
}

---
--- @param elapsed float
---
function onUpdate(elapsed)
	if schmooving then
		local randomMovement = getRandomFloat(-2.0, 2.0)
		setProperty('groundTrain.y', 760 + randomMovement)

		setProperty('boyfriend.y', characterPositions[1] + randomMovement)
		setProperty('dad.y', characterPositions[2] + randomMovement)

		setProperty('bgEffect.alpha', getProperty('phillyWindow.alpha') - 0.6)
		setProperty('bgEffect.color', getProperty('phillyWindow.color'))

		trainFrameTiming = trainFrameTiming + elapsed;
		if trainFrameTiming >= 1 / 60 then
			updateBackgroundPosition()
			trainFrameTiming = 0
		end
	end
end

function updateBackgroundPosition()
	setProperty('phillyWindow.x', getProperty('phillyWindow.x') + 50)

	if getProperty('phillyWindow.x') > -1309.65 then
		setProperty('phillyWindow.x', -2776.4)
		-- 3458
		-- 2766.4
	end
end

local isEventEnabled = false
function toggleEvent()
	if isEventEnabled then
		setProperty('bg.visible', true)
		setProperty('city.visible', true)
		setProperty('streetBehind.visible', true)
		setProperty('phillyStreet.visible', true)
		setProperty('phillyTrain.visible', true)

		setProperty('boyfriend.color', 0xFFFFFF)
		setProperty('dad.color', 0xFFFFFF)
		setProperty('gf.visible', true)

		setProperty('groundTrain.visible', false)

		schmooving = false
		loadGraphic('phillyWindow', 'philly/window')
		setProperty('phillyWindow.x', -10)

		setProperty('defaultCamZoom', defaultCameraZooming)
	else
		setProperty('bg.visible', false)
		setProperty('city.visible', false)
		setProperty('streetBehind.visible', false)
		setProperty('phillyStreet.visible', false)
		setProperty('phillyTrain.visible', false)

		setProperty('boyfriend.color', 0x000000)
		setProperty('dad.color', 0x000000)
		setProperty('gf.visible', false)

		setProperty('groundTrain.visible', true)

		schmooving = true
		loadGraphic('phillyWindow', 'philly/longWindow')
		setProperty('phillyWindow.x', -2776.4)

		setProperty('defaultCamZoom', defaultCameraZooming - 0.2)
	end

	cameraFlash('camGame', '0xFFFFFF', 0.15, true)
	isEventEnabled = not isEventEnabled
end