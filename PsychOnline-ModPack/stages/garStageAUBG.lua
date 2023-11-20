function onCreate()
	-- background shit
	makeLuaSprite('garStageAUBG', 'garStageAUBG', -600, -140);
	setScrollFactor('garStageAUBG', 0.8, 0.8);
	
	makeLuaSprite('garStageAU', 'garStageAU', -600, -140);
	setScrollFactor('garStageAU', 1, 1);
	scaleObject('garStageAU', 1, 1);

	addLuaSprite('garStageAUBG', false);
	addLuaSprite('garStageAU', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end