function onCreate()
    addCharacterToList('sky-annoyed', 'dad')

    makeAnimatedLuaSprite("shift", "bg_normal", -388.05 - 1200, -202);
    addAnimationByIndices("shift", "idle", "bg", "5", 24);
    addAnimationByPrefix('shift', 'bop', 'bg', 24, false);
     objectPlayAnimation('shift', 'idle');
    setGraphicSize('shift', 3500, 1350)
    addLuaSprite("shift", false);
end