function onCreate()
	makeLuaSprite('SkyDay', 'SkyDay', -190, -20);
	setScrollFactor('SkyDay', 0.9, 0.9);
	scaleObject('SkyDay', 1.1, 1.1);

	makeLuaSprite('City', 'City', -190, -20);
	setScrollFactor('City', 0.9, 0.9);
	scaleObject('City', 1.1, 1.1);

	makeLuaSprite('Grass', 'Grass', -200, 11);
	setScrollFactor('Grass', 0.9, 0.9);
	scaleObject('Grass', 1.1, 1.1);

	makeLuaSprite('Street', 'Street', -200, 19);
	setScrollFactor('Street', 0.9, 0.9);
	scaleObject('Street', 1.1, 1.1);

	addLuaSprite('SkyDay', false);
	addLuaSprite('City', false);
	addLuaSprite('Grass', false);
	addLuaSprite('Street', false);

	close(false);
end