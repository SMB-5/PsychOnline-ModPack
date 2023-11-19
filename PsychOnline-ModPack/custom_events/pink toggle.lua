local show = false
local songSpeed = 0
-- local flashStrength = 0

function onCreatePost()
  makeAnimatedLuaSprite('pink', 'pink/hearts', -25, 0)
  addAnimationByPrefix('pink', 'boil', 'Symbol 2000', 24, true)
  playAnim('pink', 'boil')
  setObjectCamera('pink', 'other')
  setProperty('pink.alpha', 0)
  addLuaSprite('pink', true)

  -- look i know i'm supposed to use a shader but like
  -- i cant be bothered to learn how to implement that sorry
  makeAnimatedLuaSprite('pinkglow', 'pink/hearts', -25, 0)
  addAnimationByPrefix('pinkglow', 'boil', 'Symbol 2000', 24, true)
  playAnim('pinkglow', 'boil')
  setObjectCamera('pinkglow', 'other')
  setProperty('pinkglow.alpha', 0)
  addLuaSprite('pinkglow', true)
  setBlendMode('pinkglow', 'add')

  makeLuaSprite('pink2', 'pink/vignette', -500,-500)
  addLuaSprite('pink2')
  scaleObject('pink2', 5, 5)
  setProperty('pink2.alpha', 0)
  setObjectCamera('pink2', 'hud')

  makeLuaSprite('pink22', 'pink/vignette2', 0,0)
  addLuaSprite('pink22')
  scaleObject('pink22', 1, 1)
  setProperty('pink22.alpha', 0)
  setObjectCamera('pink22', 'hud')

	songSpeed = playbackRate
end

local fadeTime = 0.75 -- i found you fader!
local heartyID = 0
local heartyName = ''
-- local alivePar = {}
local lifespan = 0
local heartEmitter = {500, 1050}
local particleWidth = 600.225
function onTimerCompleted(tag, loops, loopsLeft)
  if tag == 'hearty' and show then
    heartyID = heartyID + 1
    heartyName = 'lilHeart'..heartyID
    -- table.insert(alivePar, heartyName, true)
    lifespan = getRandomFloat(4.0, 4.5) / songSpeed
    makeAnimatedLuaSprite(heartyName, 'pink/littleheart', heartEmitter[1] + getRandomFloat(0-particleWidth, particleWidth), heartEmitter[2])
    addAnimationByPrefix(heartyName, 'hearts', 'littleheart', 24, true)
    setObjectCamera(heartyName, 'hud')
    setBlendMode(heartyName, 'add')
    scaleObject(heartyName, 1.75, 1.75)
    addLuaSprite(heartyName, true)
    setProperty(heartyName..'.velocity.x', getRandomFloat(-50, 50) * songSpeed)
    setProperty(heartyName..'.velocity.y', getRandomFloat(-800, -400) * songSpeed)
    setObjectCamera(heartyName, 'hud')
    setObjectOrder(heartyName, 0)
    playAnim(heartyName, 'hearts', true, false, getRandomInt(0,2))
    addLuaSprite(heartyName, true)
    doTweenX('vTweenX'..heartyID, heartyName..'.velocity', getRandomFloat(-100, 100) * songSpeed, lifespan, 'linear')
    doTweenY('vTweenY'..heartyID, heartyName..'.velocity', getRandomFloat(-800, 0) * songSpeed, lifespan, 'linear')
    doTweenX('dTweenX'..heartyID, heartyName..'.drag', getRandomFloat(5, 10) * songSpeed, lifespan, 'linear')
    doTweenY('dTweenY'..heartyID, heartyName..'.drag', getRandomFloat(5, 10) * songSpeed, lifespan, 'linear')
    doTweenX('sTweenX'..heartyID, heartyName..'.scale', 0, lifespan, 'linear')
    doTweenY('sTweenY'..heartyID, heartyName..'.scale', 0, lifespan, 'linear')
  end
end

local removeHeart = ''
function onTweenCompleted(tag)
  if string.find(tag, 'dTweenY') then
    removeHeart = 'lilHeart'..stringSplit(tag, 'Y')[2]
    removeLuaSprite(removeHeart)
    -- table.remove(removeHeart)
  end
end

function onBeatHit()
  if show then
    if curBeat % 2 == 1 then
      setProperty('pink2.alpha', 0.55)
      setProperty('pink22.alpha', 0.8)
      doTweenAlpha('pinkTw3', 'pink2', 0.3, 0.6 / songSpeed, 'sinein')
      doTweenAlpha('pinkTw33', 'pink22', 0.5, 0.6 / songSpeed, 'sinein')
    
      setProperty('pink.alpha', 0.5)
      doTweenAlpha('pinkTw', 'pink', 1, 0.6 / songSpeed, 'sinein')
    
      setProperty('pinkglow.alpha', 0.75)
      doTweenAlpha('pinkTwGlow', 'pinkglow', 0, 0.6 / songSpeed, 'sinein')
      -- fadeTime = 0.75
      -- flashStrength = 0.5
    end
    -- camWhee()
  end
end

-- wheePower = 0.35
-- function camWhee()
--   if curSong ~= 'heartbeat' and curSong ~= 'pinkwave' then
--     if curBeat % 2 == 0 then
--       setProperty('camGame.angle', 0-wheePower)
--       setProperty('camHUD.angle', 0-wheePower)
--     else
--       setProperty('camGame.angle', wheePower)
--       setProperty('camHUD.angle', wheePower)
--     end
--     triggerEvent('Add Camera Zoom', 0.015, 0.025)
--     doTweenAngle('gameAngle', 'camGame', 0, 0.4 / songSpeed, 'easeinout')
--     doTweenAngle('hudAngle', 'camHUD', 0, 0.4 / songSpeed, 'easeinout')
--   end
-- end

function onEvent(t, v1, v2)
  if t == 'pink toggle' then
    show = not show
    setBlendMode('pink2', 'add')
    setBlendMode('pink22', 'add')
    if show then
      fadeTime = tonumber(v1)*2 / songSpeed
      runTimer('hearty', getRandomFloat(0.3, 0.4) / songSpeed, 0)
      -- camWhee()
      setBlendMode('pink', 'hardlight')
      setProperty('pink2.alpha', 0.55)
      setProperty('pink22.alpha', 0.8)
      doTweenAlpha('pinkTw', 'pink', 1, 0.3 / songSpeed, 'easein')
      doTweenAlpha('pinkTw3', 'pink2', 0.3, 0.4 / songSpeed, 'sinein')
      doTweenAlpha('pinkTw33', 'pink22', 0.5, 0.4 / songSpeed, 'sinein')
    
      setProperty('pinkglow.alpha', 0.5)
      doTweenAlpha('pinkTwGlow', 'pinkglow', 0, 0.6 / songSpeed, 'sinein')
      -- flashStrength = 1
    elseif not show then
      fadeTime = tonumber(v1)*2 / songSpeed
      if v1 == nil or v1 == '' then fadeTime = 0.01 / songSpeed end
      -- debugPrint(fadeTime, ' ', v1)
      cancelTimer('hearty')
      setBlendMode('pink', 'add')
      setBlendMode('pink22', 'add')
      -- camWhee()
      setProperty('pink2.alpha', 0.75)
      setProperty('pink22.alpha', 1)
      cancelTween('pinkTw3')
      cancelTween('pinkTw33')
      doTweenAlpha('pinkTw', 'pink', 0, fadeTime/1.25, 'easeinout')
      doTweenAlpha('pinkTw2', 'pink2', 0, fadeTime, 'easeinout')
      doTweenAlpha('pinkTw22', 'pink22', 0, fadeTime, 'easeinout')
    
      setProperty('pinkglow.alpha', 1)
      doTweenAlpha('pinkTwGlow', 'pinkglow', 0, fadeTime/3, 'easeinout')
      -- flashStrength = 1
    end
  end
end

-- -- uses cubeInOut easing as its the only one needed for this script.
-- local newVal = 0
-- function tweenFlashes(elapsed)
--   for k, _ in pairs(alivePar) do
--     setProperty('.useColorTransform', true)
--     if flashStrength > 0 then
--       flashStrength = inOutCubic(elapsed, 255, -flashStrength, fadeTime)
--       if flashStrength < 0 then flashStrength = 0 end
--       setProperty(k..'.colorTransform.redOffset', flashStrength)
--       setProperty(k..'.colorTransform.greenOffset', flashStrength)
--       setProperty(k..'.colorTransform.blueOffset', flashStrength)
--     else
--       return
--     end
--   end
-- end

-- -- function onUpdatePost(elapsed)
-- --   tweenFlashes(elapsed)
-- -- end

-- -- https://github.com/EmmanuelOga/easing/blob/master/lib/easing.lua
-- -- t = elapsed time
-- -- b = begin
-- -- c = change == ending - beginning
-- -- d = duration (total time)
-- local function inOutCubic(t, b, c, d)
--   t = t / d * 2
--   if t < 1 then
--     return c / 2 * t * t * t + b
--   else
--     t = t - 2
--     return c / 2 * (t * t * t + 2) + b
--   end
-- end