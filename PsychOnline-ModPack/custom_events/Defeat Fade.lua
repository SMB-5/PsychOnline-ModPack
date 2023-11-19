function onEvent(eventName, value1, value2)
    if eventName == 'Defeat Fade' then
        local fadeType = tonumber(v1)
        if v1 == nil or v1 == '' then fadeType = 0 end

        if fadeType == 0 then
            doTweenAlpha('defeatEnter1', 'lol thing', 1, 0.7, 'quadinout')
            doTweenAlpha('defeatEnter2', 'deadBG', 1, 0.7, 'quadinout')
            doTweenAlpha('defeatEnter3', 'deadFG', 1, 0.7, 'quadinout')
        elseif fadeType == 1 then
            doTweenAlpha('defeatEnter1', 'lol thing', 0, 0.7, 'quadinout')
            doTweenAlpha('defeatEnter2', 'deadBG', 0, 0.7, 'quadinout')
            doTweenAlpha('defeatEnter3', 'deadFG', 0, 0.7, 'quadinout')
        end
    end
end