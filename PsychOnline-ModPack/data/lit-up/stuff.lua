function onCreate()
    
end

function onStepHit()
    if stepHitFuncs[curStep] then 
        stepHitFuncs[curStep]()
    end
end

stepHitFuncs = {
    [256] = function()
        setProperty('defaultCamZoom', 0.75);
    end,
    [320] = function()
        setProperty('defaultCamZoom', 0.85);
    end,
    [384] = function()
        setProperty('defaultCamZoom', 0.58);
    end,
    [479] = function()
        setProperty('defaultCamZoom', 0.75);
    end,
    [511] = function()
        setProperty('defaultCamZoom', 0.58);
    end,
    [607] = function()
        setProperty('defaultCamZoom', 0.75);
    end,
    [639] = function()
        setProperty('defaultCamZoom', 0.6);
    end,
    [895] = function()
        setProperty('defaultCamZoom', 0.58);
    end,
    [991] = function()
        setProperty('defaultCamZoom', 0.75);
    end,
    [1024] = function()
        setProperty('defaultCamZoom', 0.58);
    end,
    [1120] = function()
        setProperty('defaultCamZoom', 0.75);
    end,
    [1152] = function()
        setProperty('defaultCamZoom', 0.6);
    end
}