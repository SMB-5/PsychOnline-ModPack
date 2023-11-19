
function onCreate()
    makeAnimatedLuaSprite('bg', 'defeat/defeat', -545, -175);
    addAnimationByPrefix('bg', 'bop', 'defeat', 24, false)
    addAnimationByPrefix('bg', 'freeze', 'defeat', 0, false)
    scaleObject('bg', 1.25, 1.25)
    setProperty('bg.antialiasing', getPropertyFromClass('ClientPrefs', 'globalAntialiasing'))
    addLuaSprite('bg', false);
    playAnim('bg', 'bop')

    makeLuaSprite('iluminao omaga', 'defeat/iluminao omaga', -545, 125);
    setProperty('iluminao omaga.antialiasing', getPropertyFromClass('ClientPrefs', 'globalAntialiasing'))
    addLuaSprite('iluminao omaga', true);
    -- scaleObject('iluminao omaga', 1.2, 1.2)
    setBlendMode('iluminao omaga', 'add')

    makeLuaSprite('lol thing', 'defeat/lol thing', -1015, 15);
    scaleObject('lol thing', 1.47, 1.47)
    setScrollFactor('lol thing', 0.7, 0.7)
    setProperty('lol thing.antialiasing', getPropertyFromClass('ClientPrefs', 'globalAntialiasing'))

    makeLuaSprite('deadBG', 'defeat/deadBG', -800, 425);
    scaleObject('deadBG', 0.454, 0.454)
    setScrollFactor('deadBG', 0.7, 0.7)
    setProperty('deadBG.antialiasing', getPropertyFromClass('ClientPrefs', 'globalAntialiasing'))

    makeLuaSprite('deadFG', 'defeat/deadFG', -715, 695);
    scaleObject('deadFG', 0.445, 0.445)
    setScrollFactor('deadFG', 1.45, 0.65)
    setProperty('deadFG.antialiasing', getPropertyFromClass('ClientPrefs', 'globalAntialiasing'))

    setProperty('lol thing.alpha', 0)
    setProperty('deadBG.alpha', 0)
    setProperty('deadFG.alpha', 0)

    addLuaSprite('lol thing', false);
    addLuaSprite('deadBG', false);
    addLuaSprite('deadFG', true);
end

function onCreatePost()
	setProperty('gf.alpha', 0);
end

function onBeatHit()
    if curBeat % 4 == 0 and getProperty('iluminao omaga.alpha') > 0 then
        playAnim('bg', 'bop', true)
    end
end