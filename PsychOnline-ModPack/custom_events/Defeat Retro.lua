local kaderEngine = false
function onEvent(eventName, value1, value2)
    if eventName == 'Defeat Retro' then
        kaderEngine = not kaderEngine

        if kaderEngine then
            setProperty('iluminao omaga.alpha', 0)
            setProperty('lol thing.alpha', 0)
            setProperty('deadBG.alpha', 0)
            setProperty('deadFG.alpha', 0)
        else
            triggerEvent('Change Character', '0', 'bf-defeat-scared')
            triggerEvent('Change Character', '1', 'black')
            setProperty('iluminao omaga.alpha', 1)
            setProperty('lol thing.alpha', 1)
            setProperty('deadBG.alpha', 1)
            setProperty('deadFG.alpha', 1)
        end
    end
end