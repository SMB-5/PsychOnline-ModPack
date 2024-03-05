--Last Edited 10/12/21 by SaturnSpades
--Tricky mod credits will be put here temporarily until in-game credits can be modified within Lua
--Tricky Mod Developers: Banbuds, Rosebud, KadeDev, CVal, YingYang48, JADS, Moro
--Special Thanks: Tom Fulp, Krinkels, GWebDev, Tsuraran
local allowCountdown = false
function onStartCountdown()
    -- Block the first countdown and start cutscene
    if not allowCountdown and isStoryMode and not seenCutscene then
        startVideo('HellClownIntro')
	    allowCountdown = true;
        return Function_Stop;
    end
	return Function_Continue;
end
function onCreate()

    --Adds Lua Sprites

    makeLuaSprite('TrickyStatic', 'TrickyStatic', -580, -90);
    scaleLuaSprite('TrickyStatic', 10, 10);
    addLuaSprite('TrickyStatic', true)
    setPropertyLuaSprite('TrickyStatic', 'alpha', 0)

    makeAnimatedLuaSprite('Hank', 'Hank', 700, 410)
    addAnimationByPrefix('Hank', 'Hank', 'Hank', 24, true)
    addLuaSprite('Hank', false)
    objectPlayAnimation('Hank', 'Hank')
   
end

function opponentNoteHit(id, direction, noteType, isSustainNote)

    local luckyRoll = math.random(1, 30)

    if (luckyRoll >= 15 and curStep <= 2805 and curStep >= 160) then
        runTimer('static', 0, 1)
        runTimer('TrickyAlpha', 0.1, 1)
	end

    cameraShake('game', 0.01, 0.1)
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    runTimer('TrickyAlpha', 0.05, 1)
end

function onTimerCompleted(tag, loops, loopsLeft)

    if tag == 'TrickyAlpha' then
        setPropertyLuaSprite('TrickyStatic', 'alpha', 0)
    end

    if tag == 'static' then
        playSound('staticSound')
        setPropertyLuaSprite('TrickyStatic', 'alpha', 0.2)
    end

    if tag == 'startCount' then
        --removeLuaSprite('Black')
        --setProperty('dad.alpha', 1)
        startCountdown()
    end

end


function onEndSong()
    if isStoryMode and not seenCutscene then
        startVideo('HellClownOutro')
        seenCutscene = true
        return Function_Stop
    end
    return Function_Continue
end