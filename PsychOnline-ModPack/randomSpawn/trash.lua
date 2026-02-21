upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	makeGroup('trashLayer');
	addInstance('trashLayer', true);
	
	for i = 1, 3 do
		local t = 'trashCache' .. i;
		
		makeLuaSprite(t, 'anywhereUSA/trash/' .. i, 200, 200);
		addLuaSprite(t, true);
		setObjAlpha(t, 0.00001);
	end
	
	timeT = getRandomInt(500, 3000) / 1000;
end

function destroyCache()
	for i = 1, 3 do
		setObjAlpha('trashCache' .. i, 0);
	end
end

totTime = 0;
timeT = 0;
canSpawn = false;
function onUpdatePost(e)
	if inGameOver then return; end
	
	totTime = totTime + (e * playbackRate);
	if totTime >= timeT then
		if canSpawn then spawnTrash(); end
		totTime, timeT = 0, getRandomInt(500, 3000) / 1000;
	end
	
	if keyboardJustPressed('SPACE') then spawnTrash(); end
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Trash Can Spawn'] = function()
		canSpawn = not canSpawn;
	end
}

totTrash = 0;
trashOffset = {{51, 84}, {107, 55}, {52, 47}};
trashScale = {1.14814814, 1.16289592, 1.17582417};
function spawnTrash()
	totTrash = totTrash + 1;
	local t = 'groundTrash' .. totTrash;
	local sel = getRandomInt(1, 3);
	local x = dadXProper() + ((720 + Random(100)) * upScale);
	makeLuaSprite(t, 'anywhereUSA/trash/' .. tostring(sel), x, (658 + getRandomInt(-50, 250)) * upScale);
	scaleObject(t, trashScale[sel] * upScale, trashScale[sel] * upScale);
	addToOffsets(t, trashOffset[sel][1] * upScale, trashOffset[sel][2] * upScale);
	setObjectColor(t, 0x00c79efe);
	addToGrp(t, 'trashLayer');
end
