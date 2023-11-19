objUnspawn = {}
spawnedObjects = {}
totObj = 0;
upScale = 1 / 0.7;
objOff = {
	['ENEMY BASE'] = {496, 221},
	['TWO TOWERS'] = {376, 308}
}
function onCreatePost()
	luaDebugMode = true;
	for i = 0, getProperty('eventNotes.length') - 1 do
		if getPropertyFromGroup('eventNotes', i, 'event') == 'Spawn BG Object' then
			local toSpawn = getPropertyFromGroup('eventNotes', i, 'value1');
			
			if toSpawn ~= '' then
				totObj = totObj + 1;
				
				local sprToMake = 'battleBG' .. toSpawn .. totObj;
				table.insert(objUnspawn, {
					s = getPropertyFromGroup('eventNotes', i, 'strumTime'),
					o = toSpawn,
					t = sprToMake
				});
				
				makeLuaSprite(sprToMake, 'wasteland/objectEvents/' .. toSpawn, 0, 117 * upScale);
				scaleObject(sprToMake, upScale, upScale);
				setScrollFactor(sprToMake, 0.35, 0.35);
				setProperty(sprToMake .. '.offset.x', getProperty(sprToMake .. '.offset.x') + (objOff[toSpawn][1] * upScale));
				setProperty(sprToMake .. '.offset.y', getProperty(sprToMake .. '.offset.y') + (objOff[toSpawn][2] * upScale));
				setObjectOrder(sprToMake, getObjectOrder('city') + 1);
				setProperty(sprToMake .. '.alpha', 0.00001);
			end 
		end
	end
	table.sort(objUnspawn, function(a, b) return a.s < b.s; end);
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		createCallback('setObjVelX', function(o:String, v:Float) {
			return LuaUtils.getObjectDirectly(o, false).velocity.x = v;
		});
	]]);
end

function onUpdatePost()
	while #objUnspawn > 0 and objUnspawn[1].s <= getSongPosition() do
		table.insert(spawnedObjects, 1, objUnspawn[1]);
		table.remove(objUnspawn, 1);
		
		spawnObject(spawnedObjects[1]);
	end
	if #spawnedObjects > 0 then
		for i = 1, #spawnedObjects do
			local t = spawnedObjects[i];
			if t then
				setObjVelX(t.t, -4.5 * getProperty('bgSpeed'));
			end
		end
	end
end

function spawnObject(obj) --moves the actual object to the stage when it is called to be spawned
	local daTag = obj.t;
	
	setProperty(daTag .. '.alpha', 1);
	local camX = ((getProperty('camGame.scroll.x') - ((640 / 0.7) - 640)) * 0.35);
	setProperty(daTag .. '.x', camX + (2000 * upScale));
end
