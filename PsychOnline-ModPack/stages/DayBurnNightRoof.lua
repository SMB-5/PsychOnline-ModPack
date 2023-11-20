function onCreate()
	-- background shit
	
	makeLuaSprite('sky', 'sky', -600, -800);
	setScrollFactor('sky', 0.9, 0.9);
	scaleObject('sky', 1.0, 1.0);
	
	makeLuaSprite('Buildings', 'Buildings', -250, -300);
	setScrollFactor('Buildings', 0.9, 0.9);
	scaleObject('Buildings', 0.7, 0.7);

	makeLuaSprite('Roof', 'Roof', -500, 700);
	setScrollFactor('Roof', 0.9, 0.9);
	scaleObject('Roof', 1.0, 1.0);

	addLuaSprite('sky', false);
	addLuaSprite('Buildings', false);
	addLuaSprite('Roof', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end