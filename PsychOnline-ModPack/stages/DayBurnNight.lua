function onCreate()
	-- background shit
	
	makeLuaSprite('SkyNight', 'SkyNight', -500, -90);
	setScrollFactor('SkyNight', 0.9, 0.9);
	scaleObject('SkyNight', 1.7, 1.7);
	
	makeLuaSprite('CityNight', 'CityNight', -300, -20);
	setScrollFactor('CityNight', 0.9, 0.9);
	scaleObject('CityNight', 1.2, 1.2);
	
	makeLuaSprite('GrassNight', 'GrassNight', -300, -20);
	setScrollFactor('GrassNight', 0.9, 0.9);
	scaleObject('GrassNight', 1.2, 1.2);
	
	makeLuaSprite('StreetNight', 'StreetNight', -300, -60);
	setScrollFactor('StreetNight', 0.9, 0.9);
	scaleObject('StreetNight', 1.2, 1.2);

	addLuaSprite('SkyNight', false);
	addLuaSprite('CityNight', false);
	addLuaSprite('GrassNight', false);
	addLuaSprite('StreetNight', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end