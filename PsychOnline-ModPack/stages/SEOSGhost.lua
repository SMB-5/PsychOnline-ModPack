function onCreate()
	-- background shit
	makeAnimatedLuaSprite('smokey', 'garSmoke', -500, -300)
	addAnimationByPrefix('smokey','Idle','smokey instance','24',true)
	objectPlayAnimation('smokey','Idle',false)
	scaleObject('smokey', 1.7, 1.7);
	
	
	makeLuaSprite('gardead', 'gardead', -200, 600);
	setScrollFactor('garDead', 0.9, 0.9);
	scaleObject('gardead', 1.0, 1.0);
	
	makeLuaSprite('garStagebgAlt', 'garStagebgAlt', -400, -50);
	setScrollFactor('garStagebgAlt', 0.9, 0.9);
	scaleObject('garStagebgAlt', 0.9, 0.9);
	
	makeLuaSprite('garStagealt', 'garStagealt', -400, -99);
	setScrollFactor('garStagealt', 0.9, 0.9);
	scaleObject('garStagealt', 0.9, 0.9);
	
	makeAnimatedLuaSprite('smokey2', 'garSmoke', -500, -600)
	addAnimationByPrefix('smokey2','Idle','smokey instance','24',true)
	objectPlayAnimation('smokey2','Idle',false)
	scaleObject('smokey2', 1.7, 1.7);
	
	addLuaSprite('garStagebgAlt', false);
	addLuaSprite('smokey2', false);
	addLuaSprite('garStagealt', false);
	addLuaSprite('smokey', true);
	addLuaSprite('gardead', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end