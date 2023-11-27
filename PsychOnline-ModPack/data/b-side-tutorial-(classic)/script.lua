local characterZooms = {0, 0}

function onCreatePost()
	if getProperty('defaultCamZoom') == 0 then
		setProperty('defaultCamZoom', 1)
	end
	characterZooms[1] = getProperty('defaultCamZoom') + 0.3
	characterZooms[2] = getProperty('defaultCamZoom')
end

function onBeatHit()
	if curBeat == 16 then
		cameraFlash('camGame', 'FFFFFF', 0.5, false)

		setProperty('dad.x', getProperty('gf.x'))
		setProperty('dad.y', getProperty('gf.y'))
		setProperty('gf.visible', false)
	end
end

---
--- @param character string
---
function onMoveCamera(character)
	if character == 'dad' then
		setProperty('defaultCamZoom', characterZooms[1])
	else
		setProperty('defaultCamZoom', characterZooms[2])
	end
end