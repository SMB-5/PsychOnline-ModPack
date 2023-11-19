local balls = true

function onCreate() 

	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf_ourple')
	makeLuaSprite('backstage','bg/bckrom', -550,-580)
	scaleObject('backstage', 1.75, 1.75)
	updateHitbox('backstage')
	addLuaSprite('backstage',false)


	makeAnimatedLuaSprite('sloth','evils/metal', 375, 450)
	addAnimationByPrefix('sloth', 'metalsos','metal', 24, true)
	setScrollFactor('sloth', 0.9, 0.9)
	addLuaSprite('sloth',false)

	makeAnimatedLuaSprite('greed','evils/grinch', -50, 575)
	addAnimationByPrefix('greed', 'grinchsos','grinch', 24, true)
	setScrollFactor('greed', 1.2, 1.2)
	scaleObject('greed', 1.2, 1.2)
	addLuaSprite('greed',true)

	makeAnimatedLuaSprite('wrath','evils/rage', 160, 240)
	addAnimationByPrefix('wrath', 'angrysos','rage', 24, true)
	setScrollFactor('wrath', 0.92, 0.92)
	scaleObject('wrath', 1, 1)
	addLuaSprite('wrath',false)

end

function onUpdate(elapsed)
    if balls == true then
        songPos = getSongPosition()
        local currentBeat = (songPos/5000)*(curBpm/60)        
        doTweenY('balls2', 'sloth', 300 + 70*math.sin((currentBeat+12*12)*math.pi), 1.3)
		doTweenY('balls3', 'greed', 400 + 60*math.sin((currentBeat+12*12)*math.pi), 1.3)
		doTweenY('balls4', 'wrath', 120 - 70*math.sin((currentBeat+12*12)*math.pi), 1.3)
    end
end