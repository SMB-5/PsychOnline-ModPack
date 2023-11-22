ico2 = {}
ico1 = {}
ico3 = {}

bb = false
intween = false

songstarted = false
function onCreatePost()
    ico2.order = getObjectOrder('iconP2')
    ico2.ogh = 0
    ico2.ogw = 0
    ico2.name = ''
    ico2.idlename = ''
    ico2.losename = ''
    ico2.offset = 0
    ico2.offsety = 0
    ico2.noxml = false

    ico1.order = getObjectOrder('iconP1')
    ico1.ogh = 0
    ico1.ogw = 0
    ico1.name = ''
    ico1.idlename = ''
    ico1.losename = ''
    ico1.winname = ''
    ico1.offset = 0
    ico1.offsety = 0
    ico1.noxml = false

    if songName == 'ChallengEdd' then
        ico1.name = 'iconxml/bf'
        ico1.idlename = 'idle'
        ico1.losename = 'lose'
        ico1.winname = 'idle'
        ico2.name = 'iconxml/sky'
        ico2.idlename = 'idle'
        ico2.losename = 'lose'
        ico2.winname = 'idle'

        ico3.order = getObjectOrder('iconP2') - 1
        ico3.ogh = 0
        ico3.ogw = 0
        ico3.name = 'iconxml/bb'
        ico3.idlename = 'idle'
        ico3.losename = 'lose'
        ico3.winname = 'idle'
        ico3.offset = 0
        ico3.offsety = 0
        ico3.noxml = false

    elseif songName == 'All-In-One' then
        ico1.name = 'iconxml/bf'
        ico1.idlename = 'idle'
        ico1.losename = 'lose'
        ico1.winname = 'win'
        ico2.name = 'iconxml/lexi'
        ico2.idlename = 'idle'
        ico2.losename = 'lose'
        ico2.winname = 'win'
    else
        ico2.noxml = true
        ico1.noxml = true
        ico3.noxml = true
    end

    if ico1.noxml == false then
        setProperty('iconP1.visible',false);
        makeAnimatedLuaSprite('theicon1', ico1.name, getProperty('iconP1.x'), 0)
        addAnimationByIndices('theicon1', 'idle', ico1.idlename, '0', 0)
        addAnimationByIndices('theicon1', 'lose', ico1.losename, '0', 0)
        addAnimationByIndices('theicon1', 'win', ico1.winname, '0', 0)
        addLuaSprite('theicon1')
        setObjectCamera('theicon1', 'hud')
        objectPlayAnimation('theicon1', 'idle')
        setObjectOrder('theicon1', ico1.order)
        setProperty('theicon1.y', getProperty('healthBar.y') - (getProperty('theicon1.height')/2) + ico1.offsety)

        setProperty('theicon1.flipX', true)
    end

    if ico2.noxml == false then
        setProperty('iconP2.visible',false);
        makeAnimatedLuaSprite('theicon2', ico2.name, getProperty('iconP2.x'), 0)
        addAnimationByIndices('theicon2', 'idle', ico2.idlename, '0', 0)
        addAnimationByIndices('theicon2', 'lose', ico2.losename, '0', 0)
        addAnimationByIndices('theicon2', 'win', ico2.winname, '0', 0)
        addLuaSprite('theicon2')
        setObjectCamera('theicon2', 'hud')
        objectPlayAnimation('theicon2', 'idle')
        setObjectOrder('theicon2', ico2.order)
        setProperty('theicon2.y', getProperty('healthBar.y') - (getProperty('theicon2.height')/2) + ico2.offsety)
    end

    if ico3.noxml == false then
        makeAnimatedLuaSprite('theicon3', ico3.name, getProperty('iconP2.x'), 0)
        addAnimationByIndices('theicon3', 'idle', ico3.idlename, '0', 0)
        addAnimationByIndices('theicon3', 'lose', ico3.losename, '0', 0)
        addAnimationByIndices('theicon3', 'win', ico3.winname, '0', 0)
        addLuaSprite('theicon3')
        setObjectCamera('theicon3', 'hud')
        objectPlayAnimation('theicon3', 'idle')
        setObjectOrder('theicon3', ico3.order)
        setProperty('theicon3.y', getProperty('healthBar.y') - (getProperty('theicon3.height')/2) + ico3.offsety)
        setProperty('theicon3.visible', false)
    end

end

function onUpdatePost(elapsed)
    if ico1.noxml == false then
    setProperty('theicon1.x', getProperty('healthBar.x') + (getProperty('healthBar.width') * (remapToRange(getProperty('healthBar.percent'), 0, 100, 100, 0) * 0.01) - 26) + ico1.offset)
    end

    if ico2.noxml == false and intween == false and bb == false then
    setProperty('theicon2.x', getProperty('healthBar.x') + (getProperty('healthBar.width') * (remapToRange(getProperty('healthBar.percent'), 0, 100, 100, 0) * 0.01)) - (getProperty('theicon2.width') - 26) + ico2.offset)
    elseif ico2.noxml == false and intween == false and bb == true then
        setProperty('theicon2.x', getProperty('healthBar.x') + (getProperty('healthBar.width') * (remapToRange(getProperty('healthBar.percent'), 0, 100, 100, 0) * 0.01) - 26) + 100 + ico1.offset)
    end

    if ico3.noxml == false then
        setProperty('theicon3.x', getProperty('healthBar.x') + (getProperty('healthBar.width') * (remapToRange(getProperty('healthBar.percent'), 0, 100, 100, 0) * 0.01)) - (getProperty('theicon3.width') - 26) + ico3.offset)
    end

    if ico1.noxml == false and songstarted == true then
        if getProperty('health') >= 1.60 then
            objectPlayAnimation('theicon1', 'win')
        elseif getProperty('health') <= 0.40 then
            objectPlayAnimation('theicon1', 'lose')
        else
            objectPlayAnimation('theicon1', 'idle')
        end
    end

    if ico2.noxml == false and songstarted == true and bb == false then
        if getProperty('health') >= 1.60 then
            objectPlayAnimation('theicon2', 'lose')
        elseif getProperty('health') <= 0.40 then
            objectPlayAnimation('theicon2', 'win')
        else
            objectPlayAnimation('theicon2', 'idle')
        end
    elseif ico2.noxml == false and songstarted == true and bb == true then
        if getProperty('health') >= 1.60 then
            objectPlayAnimation('theicon1', 'win')
        elseif getProperty('health') <= 0.40 then
            objectPlayAnimation('theicon1', 'lose')
        else
            objectPlayAnimation('theicon1', 'idle')
        end
    end

    if ico3.noxml == false and songstarted == true then
        if getProperty('health') >= 1.60 then
            objectPlayAnimation('theicon3', 'lose')
        elseif getProperty('health') <= 0.40 then
            objectPlayAnimation('theicon3', 'win')
        else
            objectPlayAnimation('theicon3', 'idle')
        end
    end

    if songstarted == true then
        if ico1.noxml == false then
            setGraphicSize('theicon1', lerp(ico1.ogw, getProperty('theicon1.width'),  boundTo(1 - (elapsed * 9), 0, 1)))
            updateHitbox('theicon1')
        end
        if ico2.noxml == false then
            setGraphicSize('theicon2', lerp(ico2.ogw, getProperty('theicon2.width'),  boundTo(1 - (elapsed * 9), 0, 1)))
            updateHitbox('theicon2')
        end
        if ico3.noxml == false then
            setGraphicSize('theicon3', lerp(ico3.ogw, getProperty('theicon3.width'),  boundTo(1 - (elapsed * 9), 0, 1)))
            updateHitbox('theicon3')
        end
    end

end

function remapToRange(value, start1, stop1, start2, stop2)
    return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1));
end

function onBeatHit()

    if songstarted == true then
	if curBeat % 2 == 0 then
        if ico2.noxml == false then
        setGraphicSize('theicon2', getProperty('theicon2.width')*1.20, getProperty('theicon2.height')*1.20)
        updateHitbox('theicon2')
        end
        if ico1.noxml == false then
        setGraphicSize('theicon1', getProperty('theicon1.width')*1.20, getProperty('theicon1.height')*1.20)
        updateHitbox('theicon1')
        end
        if ico3.noxml == false then
            setGraphicSize('theicon3', getProperty('theicon3.width')*1.20, getProperty('theicon3.height')*1.20)
            updateHitbox('theicon3')
            end
	else
	    if ico2.noxml == false then
        setGraphicSize('theicon2', getProperty('theicon2.width')*1.075, getProperty('theicon2.height')*1.075)
        updateHitbox('theicon2')
        end
        if ico1.noxml == false then
        setGraphicSize('theicon1', getProperty('theicon1.width')*1.075, getProperty('theicon1.height')*1.0755)
        updateHitbox('theicon1')
        end
        if ico3.noxml == false then
            setGraphicSize('theicon3', getProperty('theicon3.width')*1.075, getProperty('theicon3.height')*1.075)
            updateHitbox('theicon3')
        end
	end
    end

    if songName == 'ChallengEdd' then
        if curBeat == 236 then
            bb = true
            setProperty('theicon2.flipX', true)
            setProperty('theicon3.visible', true)
            intween = true
            doTweenX('changeside', 'theicon2', getProperty('theicon1.x') + 100, 0.17, 'sineOut')
        end
    end
end

function lerp(a, b, ratio)
	return a + (ratio * (b - a))
end

function boundTo(value, min, max)
    local newValue = value
    if newValue < min then
        newValue = min
    elseif newValue > max then
        newValue = max
    end
    return newValue
end

function onSongStart()
    ico2.ogw = getProperty('theicon2.width')
    ico2.ogh = getProperty('theicon2.height')
    ico1.ogw = getProperty('theicon1.width')
    ico1.ogh = getProperty('theicon1.height')
    ico3.ogw = getProperty('theicon3.width')
    ico3.ogh = getProperty('theicon3.height')
    songstarted = true
end

function onTweenCompleted(tag)
    if tag == 'changeside' then
        intween = false
    end
end