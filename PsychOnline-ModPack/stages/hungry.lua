function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'minimum_bf');
   	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx');
   	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver');
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd');

	makeLuaSprite('da_bg', 'the-background-ever', 0, 0);
	setLuaSpriteScrollFactor('da_bg', 1.0, 1.0);

	makeLuaSprite('da_counter', 'counter-thing', 580, 400);
	setLuaSpriteScrollFactor('da_counter', 1.0, 1.0);

	makeLuaSprite('ratsAss','the-background-ever-hang-up',0,0);

   	makeAnimatedLuaSprite('divide','cool_anime_thing', 520, 0);
		addAnimationByPrefix('divide','cool_anime_thing','lightning thing',24,true);
		objectPlayAnimation('divide','cool_anime_thing',false);

	addLuaSprite('da_bg', false);
	addLuaSprite('da_counter', true);
	addLuaSprite('ratsAss',true);
	addLuaSprite('divide', true);

	setProperty('ratsAss.visible',false);
	close(false);
end