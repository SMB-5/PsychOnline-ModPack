function onCreate()
	makeLuaSprite('garStagebg', 'garStagebg', -400, -50);
	setScrollFactor('garStagebg', 0.9, 0.9);
	scaleObject('garStagebg', 0.9, 0.9);

	makeLuaSprite('garStage', 'garStage', -400, -99);
	setScrollFactor('garStage', 0.9, 0.9);
	scaleObject('garStage', 0.9, 0.9);

	addLuaSprite('garStagebg', false);
	addLuaSprite('garStage', false);

	close(false);
end