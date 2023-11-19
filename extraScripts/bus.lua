upScale = 1 / 0.7;
function onCreate()
	local busScale = 1.06306306 * upScale;
	makeAnimatedLuaSprite('bus', 'street/bus/bus', 0, (341 - 334) * upScale);
	addAnimationByPrefix('bus', 'bus', 'Bus', 39);
	scaleObject('bus', busScale, busScale);
	local busCen = getObjCen('bus');
	addOffset('bus', 'bus', busCen[1], busCen[2]);
	playAnim('bus', 'bus', true);
	addLuaSprite('bus', true);
	setObjAlpha('bus', 0.00001);
	
	makeLuaSprite('hitboxUber', 'street/hitboxes/uber', (305 - 55) * upScale, (476 - 75) * upScale);
	scaleObject('hitboxUber', upScale, upScale);
	addLuaSprite('hitboxUber', true);
	setObjAlpha('hitboxUber', 0);
	
	makeLuaSprite('hitboxPico', 'street/hitboxes/pico', (854 - 355) * upScale, (475 - 75) * upScale);
	scaleObject('hitboxPico', upScale, upScale);
	addLuaSprite('hitboxPico', true);
	setObjAlpha('hitboxPico', 0);
end

bussin = false;

uberHit = false;
picoDodged = false;
reCheckPico = false;
reCheckUber = false;
shakin = false;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if bussin and not inGameOver then
		addToX('bus', (40 * (e / 0.01)) * upScale);
		
		if getObjX('bus') > (3584 - 1180) * upScale then
			bussin = false;
			callOnLuas('killBus', {});
			removeLuaSprite('bus');
			
			goto ENDBUSSIN;
		end
		
		if not shakin and getObjX('bus') > (-800 - 1180) * upScale then
			shakin = true;
			cameraShake('game', 0.005, 1.3 / playbackRate);
		end
		
		if not uberHit then
			if objectsOverlap('bus', 'hitboxUber') then
				uberHit = true;
				reCheckUber = true;
				
				runOverUber();
			end
		else
			if reCheckUber and not objectsOverlap('bus', 'hitboxUber') then
				reCheckUber = false;
				runTimer('runUber', 1.65 / playbackRate);
			end
		end
		
		if not picoDodged then
			if objectsOverlap('bus', 'hitboxPico') then
				picoDodged = true;
				reCheckPico = true;
				
				callOnLuas('picoDodge', {});
			end
		else
			if reCheckPico and not objectsOverlap('bus', 'hitboxPico') then
				reCheckPico = false;
				
				callScript('characters/pico-unloaded', 'picoBack', {});
			end
		end
		
		::ENDBUSSIN::
	end
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Bus Run In'] = function()
		setObjX('bus', (-1540 - 1180) * upScale);
		setObjAlpha('bus', 1);
		
		bussin = true;
		
		uberHit = false;
	end
}
