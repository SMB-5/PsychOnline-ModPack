function onCreate()
	setVar('doCamZooms', true);
end

function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Camera Boom Speed'] = function(v1)
		local boomSpeed = tonumber(v1);
		if boomSpeed <= 4 then
			camZoomBeats = boomSpeed;
		end
	end
}

function onBeatHit()
	if curBeat % camZoomBeats == 0 and curBeat % 4 ~= 0 then
		camZoom();
	end
end

function camZoom()
	if cameraZoomOnBeat and getProperty('camZooming') then
		local zoomGame = 0.015 * getProperty('camZoomingMult');
		local zoomHud = 0.03 * getProperty('camZoomingMult');
		setProperty('camGame.zoom', getProperty('camGame.zoom') + zoomGame);
		setProperty('camHUD.zoom', getProperty('camHUD.zoom') + zoomHud);
	end
end

function onUpdatePost()
	if not getProperty('doCamZooms') then setProperty('camZooming', false); end
end
