function onCreate() 
 	makeLuaSprite('garStagebgRise', 'garStagebgRise', -400, -50);
	setScrollFactor('garStagebgRise', 0.9, 0.9);
	scaleObject('garStagebgRise', 0.9, 0.9);
	
	makeLuaSprite('gardead', 'gardead', -200, 600);
	setScrollFactor('garDead', 0.9, 0.9);
	scaleObject('gardead', 1.0, 1.0);
	
	makeLuaSprite('garStageRise', 'garStageRise', -400, -50);
	setScrollFactor('garStageRise', 0.9, 0.9);
	scaleObject('garStageRise', 0.9, 0.9);

	addLuaSprite('garStagebgRise', false);
	addLuaSprite('garStageRise', false);
	addLuaSprite('gardead', false);

    close(true)
end