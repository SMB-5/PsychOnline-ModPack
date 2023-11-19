function onCreatePost()
    makeLuaSprite('backWall', 'chef/Back Wall Kitchen', 480, 120)
    makeLuaSprite('floor', 'chef/Chef Floor', -500, 1000)
    makeLuaSprite('backTable', 'chef/Back Table Kitchen', 150, 270)
    makeLuaSprite('oven', 'chef/oven', 1700, 480)
    makeAnimatedLuaSprite('grey', 'chef/Boppers', 1050, 580)
    makeAnimatedLuaSprite('saster', 'chef/Boppers', 1350, 580)
    makeLuaSprite('shadow', 'chef/black_overhead_shadow', -350, -300)
    makeLuaSprite('counter', 'chef/Kitchen Counter', 900, 720)
    makeLuaSprite('light', 'chef/bluelight', 100, 100)

    scaleObject('backWall', 0.8, 0.8)
    scaleObject('backTable', 0.8, 0.8)
    scaleObject('oven', 0.8, 0.8)
    scaleObject('grey', 0.8, 0.8)
    scaleObject('saster', 0.8, 0.8)
    scaleObject('counter', 0.94, 0.94)
    scaleObject('light', 0.8, 0.8)

    setProperty('light.alpha', 0.6)

    addAnimationByPrefix('grey', 'idle', 'grey', 24, false)
    addAnimationByPrefix('saster', 'idle', 'saster', 24, false)

    addLuaSprite('backWall')
    addLuaSprite('floor')
    addLuaSprite('backTable')
    addLuaSprite('oven')
    addLuaSprite('grey')
    addLuaSprite('saster')
    addLuaSprite('shadow')
    addLuaSprite('counter')
    addLuaSprite('light', true)

    setProperty('gf.visible', false)
end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('grey', 'idle', true, false, 0)
        playAnim('saster', 'idle', true, false, 0)
    end
end