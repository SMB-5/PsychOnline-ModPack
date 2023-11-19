bgchars = {}
path = ''

function onCreatePost()
    for _, v in pairs(bgchars) do
        for _, i in ipairs(v) do
            makeAnimatedLuaSprite(i[1], path..i[4], i[2], i[3])
            addAnimationByPrefix(i[1], 'idle', i[1], 24, false)
            playAnim(i[1], i[1], true)
            scaleObject(i[1], i[6], i[6])
            addLuaSprite(i[1])
            setObjectOrder(i[1], i[5])
        end
    end
end

function onCountdownTick(swagCounter)
    for k, v in pairs(bgchars) do
        if swagCounter % tonumber(k) == 0 then
            for _, i in ipairs(v) do
                playAnim(i[1], 'idle', true)
            end
        end
    end
end

function onBeatHit()
    for k, v in pairs(bgchars) do
        if curBeat % tonumber(k) == 0 then
            for _, i in ipairs(v) do
                playAnim(i[1], 'idle', true)
            end
        end
    end
end