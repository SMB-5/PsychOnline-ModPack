
function onCreate()
	-- background shit
	makeLuaSprite('sky', 'sky', -600, -300);
	setScrollFactor('sky', 0.6, 0.6);
		makeLuaSprite('cloud', 'clouds', -600, -300);
	setScrollFactor('cloud', 0.6, 0.6);
	makeLuaSprite('fence', 'fence', -650, 250);
		setScrollFactor('cloud', 0.9, 0.9);

	makeLuaSprite('bgblock', 'cornBlock', -550, 450);

	makeLuaSprite('grass', 'grass', -650, 400);

	makeLuaSprite('corn', 'corn', -650, 0);
		setScrollFactor('corn', 0.9, 0.9);

	makeLuaSprite('cornBack', 'cornBack', -650, 0);
	setScrollFactor('cornBack', 0.8, 0.8);

	addLuaSprite('sky', false);
	addLuaSprite('cloud', false);
	addLuaSprite('cornBack', false);
	addLuaSprite('corn', false);
	addLuaSprite('bgblock', false);
	addLuaSprite('fence', false);
	addLuaSprite('grass', false);

end