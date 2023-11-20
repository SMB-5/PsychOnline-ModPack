function onCreate() 
 	makeLuaSprite('DTbg', 'DTbg', -100, -300);
	setScrollFactor('DTbg', 0.8, 0.8);
	scaleObject('DTbg', 0.75, 0.75);

	makeLuaSprite('carbehind', 'carbehind', 330, 200);
	setScrollFactor('carbehind', 0.8, 0.8);
	scaleObject('carbehind', 0.7, 0.7);

	makeLuaSprite('carback', 'carbackhr', -140, 20);
	setScrollFactor('carback', 1, 1);
	scaleObject('carback', 0.8, 0.8);

	makeLuaSprite('carfront', 'carfront', -140, 20);
	setScrollFactor('carfront', 1, 1);
	scaleObject('carfront', 0.8, 0.8);

	addLuaSprite('DTbg', false);
	addLuaSprite('carbehind', false);
	addLuaSprite('carback', false);
	addLuaSprite('carfront', true);

    close(true)
end