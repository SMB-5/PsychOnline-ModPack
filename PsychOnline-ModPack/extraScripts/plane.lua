upScale = 1 / 0.7;
isFucked = false;
planeX = 0;
function onCreate()
	luaDebugMode = true;
	
	local planeOff = subScrollPos(0.19);
	planeX = ((-1058 - 74) * upScale) + planeOff[1];
	makeLuaSprite('plane', 'eddsworld/extraObjects/plane', planeX, ((130 - 32) * upScale) + planeOff[2]);
	scaleObject('plane', upScale, upScale);
	setScrollFactor('plane', 0.19, 0.19);
	addLuaSprite('plane'); 
end

function loadMix()
	isFucked = true;
	
	makeAnimatedLuaSprite('tordAirplane', 'eddsworld/end mix/tord/tordHelicopter', 0, 0);
	addAnimationByPrefix('tordAirplane', 'idle', 'idle', 30);
	addAnimationByPrefix('tordAirplane', 'parachute', 'parachute', 30, false);
	scaleObject('tordAirplane', upScale, upScale);
	local tordCen = getObjCen('tordAirplane');
	addOffset('tordAirplane', 'idle', tordCen[1] + (32 * upScale), tordCen[2] + (43 * upScale));
	addOffset('tordAirplane', 'parachute', tordCen[1] + (32 * upScale), tordCen[2] + (43 * upScale));
	playAnim('tordAirplane', 'idle', true);
	setScrollFactor('tordAirplane', 0.19, 0.19);
	setObjectOrder('tordAirplane', getObjectOrder('plane'));
	setObjAlpha('tordAirplane', 0.00001);
end

function onSongStart()
	if isFucked then setObjAlpha('tordAirplane', 0); end
end

planeActive = true;
droppedTord = false;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if inGameOver or not planeActive then return; end
	
	local planePos = planeX + (((getSongPosition() / 1000) * ((2 / 0.03))) * upScale);
	setObjX('plane', planePos);
	
	if isFucked then
		if not droppedTord then
			if planePos >= planeX + ((1058 + 1074) * upScale) then
				droppedTord = true;
				dropTord();
				
				updateTordPos(e);
			end
		else
			updateTordPos(e);
		end
	end
end

function dropTord()
	local planeAt = getObjPos('plane');
	setObjPos('tordAirplane', planeAt[1] + (getProperty('camGame.scroll.x') * 0.19) - (6 * upScale), planeAt[2] + (getProperty('camGame.scroll.y') * 0.19) - (2 * upScale));
	setObjAlpha('tordAirplane', 1);
	
	firstFall = true;
	parachuteActive = true;
end

parachuteActive = false;
fallSpd = 0;
firstFall = false;
secondFall = false;

tordTimer = 0;
parachuteX = 0;
function updateTordPos(e)
	if not parachuteActive then return; end
	
	if firstFall then
		if fallSpd < 10 then
			fallSpd = fallSpd + (0.32 * (e / 0.03));
		end
	
		addToY('tordAirplane', (fallSpd * (e / 0.03)) * upScale);
		
		local torY = getObjY('tordAirplane');
		if torY + ((130 - 32) * upScale) > (244) * upScale then
			firstFall = false;
			secondFall = true;
			parachuteX = getObjX('tordAirplane');
			
			doTweenY('pullChuteTween', 'tordAirplane', torY - (34 * upScale), 0.35 / playbackRate, 'quadOut');
			playAnim('tordAirplane', 'parachute', true);
		end
	end
	if secondFall then
		tordTimer = tordTimer + (e * 1000);
		local newPos = parachuteX + (math.floor(math.sin((tordTimer / 10) * math.pi / 180) * 35) * upScale);
		
		setObjX('tordAirplane', newPos);
	end
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['TordBot Rise'] = function()
		planeActive = false;
		parachuteActive = false;
		
		removeLuaSprite('tordAirplane');
		removeLuaSprite('plane');
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['pullChuteTween'] = function()
		setProperty('tordAirplane.velocity.y', (1 / 0.06) * upScale * playbackRate);
	end
}
