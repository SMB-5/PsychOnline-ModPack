function onCreate()
	makeLuaSprite('tower', 'tower', -225, -425)
	setScrollFactor('tower', 0.5, 0.5)

	makeLuaSprite('ground', 'floorEntity', -830, -720)
	setScrollFactor('ground', 1, 1)
	setProperty("ground.scale.x", 1.2)
	setProperty("ground.scale.y", 1.2)

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		makeLuaSprite('agotirock', 'rock', -300, -200)
		setScrollFactor('agotirock', 0.8, 0.8)
	end

	makeVideoSprite('videoSprite', 'agoti', 0, 0, 'camGame', true)
	setLuaSpriteScrollFactor('videoSprite_video', 0.0, 0.0)
	scaleObject('videoSprite_video', 1.9, 1.8)
	setObjectOrder('videoSprite_video', 0)

	addLuaSprite('tower', false)
	addLuaSprite('agotirock', false)

	addLuaSprite('ground', false)
end

-- -350 + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.5) * 12.5;

function onUpdate(elapsed)
	local songPos = getSongPosition()

	setProperty("agotirock.y", -350 + math.sin((songPos / 2000) * (bpm / 60) * 1.5) * 22.5)
	--setProperty("videoBackground.y", -350 + math.sin((songPos / 2000) * (bpm / 60) * 1.5) * 22.5);
end