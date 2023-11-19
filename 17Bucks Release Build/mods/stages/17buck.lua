
-- zoom is set to 0.8 default
local zoomboyfriend = 0.8
local zoomdad = 0.8
local zoomable = false -- if its false then the camera doesnt pan in and out (only rlly useful when you need to make the camera zoom in n stuff for a long time)

function onCreate() 

	makeLuaSprite('backstage','bg/bckrom', -550,-580)
	scaleObject('backstage', 1.75, 1.75)
	updateHitbox('backstage')
	setProperty('backstage.antialiasing', false)
	addLuaSprite('backstage',false)

	setScrollFactor('gfGroup',0.85,.85)

	-- just put the song name and then change the zoom for each character --
	if songName == "Boulevard" then
		zoomboyfriend = 0.9
		zoomdad = 0.7

		makeLuaSprite('YOUDIED','',0,0)
		makeGraphic('YOUDIED',1280,720,'FF0000')
		addLuaSprite('YOUDIED',true)
		setProperty('YOUDIED.alpha',0.00001)
		setObjectCamera('YOUDIED','other')
	end
end


function onUpdate()
	if getProperty('health') > 0.0001 then
		if zoomable then
    		if mustHitSection == false then
				setProperty('defaultCamZoom', zoomdad)
			else
				setProperty('defaultCamZoom', zoomboyfriend)
			end
		end
	end
end

function onBeatHit()
	if songName == 'Boulevard' then
		if curBeat == 240 then
			setObjectOrder('DRAMATIC',getObjectOrder('gfGroup')+1)
			doTweenZoom('camz','camGame',1.3,24,'linear')
			doTweenColor('ballsks2', 'gf', '000000', 24, 'linear')
			doTweenColor('ballsks22', 'backstage', '000000', 24, 'linear')
		end
		if curBeat == 272 then
			doTweenColor('ballsks', 'dad', '000000', 12, 'linear')
		end
		if curBeat == 304 then
			setProperty('YOUDIED.alpha',1)
			doTweenAlpha('YOUDIED','YOUDIED',0,1,'linear')

			doTweenZoom('camz','camGame',0.7,0.5,'backInOut')
            setProperty('camHUD.visible',false)
		end
		if curBeat >= 304 and curBeat < 310 then
			doTweenColor('ballsks2q', 'gf', 'FFFFFF', 0.01, 'linear')
			doTweenColor('ballsks22q', 'backstage', 'FFFFFF', 0.01, 'linear')
			doTweenColor('ballsksss', 'dad', 'FFFFFF', 0.01, 'linear')
		end
		if curBeat == 310 then
			doTweenColor('ballsks23', 'gf', '000000', 1.5, 'linear')
			doTweenColor('ballsks223', 'dad', '000000', 1.5, 'linear')
			doTweenColor('ballsks222', 'boyfriend', '000000', 1.5, 'linear')
			doTweenColor('ballsks2222', 'backstage', '000000', 1.5, 'linear')
		end
	end
end



