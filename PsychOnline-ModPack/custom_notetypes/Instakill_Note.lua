function onCreate()
	luaDebugMode = true;
	
	makeAnimatedLuaSprite('deathNoteCache', 'notes/deathNote');
	setProperty('deathNoteCache.alpha', 0.00001);
	addLuaSprite('deathNoteCache');
	setObjectCamera('deathNoteCache', 'hud');
	
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if unspawnProperty(i, 'noteType') == 'Instakill_Note' then
			unspawnProperty(i, 'texture', 'notes/deathNote');
			unspawnProperty(i, 'rgbShader.enabled', false);
			unspawnProperty(i, 'noteSplashData.disabled', true);
			unspawnProperty(i, 'ignoreNote', true);
			unspawnProperty(i, 'lowPriority', true);
			unspawnProperty(i, 'hitCausesMiss', true);
			unspawnProperty(i, 'missHealth', 4);
			unspawnProperty(i, 'earlyHitMult', 0.2);
			unspawnProperty(i, 'earlyHitMult', 0.3);
			unspawnProperty(i, 'offsetX', -165);
			unspawnProperty(i, 'offsetY', -71);
		end
	end
	
	for i = getProperty('unspawnNotes.length') - 1, 0, -1 do
		if unspawnProperty(i, 'noteType') == 'Instakill_Note' and unspawnProperty(i, 'isSustainNote') then
			removeFromGroup('unspawnNotes', i, false);
		end
	end
	
	runHaxeCode([[
		createCallback('setNoteFrameRate', function(i, f) {
			game.notes.members[i].animation.curAnim.frameRate = f;
		});
	]]);
end

function onCreatePost()
	precacheSound('death');
end

function onSpawnNote(i, d, n, s)
	if n == 'Instakill_Note' then
		setNoteFrameRate(i, 30);
	end
end

function noteMiss(i, d, n, s)
	if n == 'Instakill_Note' then
		doSound('death');
	end
end

function unspawnProperty(index, property, setter)
	if setter == nil then 
		return getPropertyFromGroup('unspawnNotes', index, property);
	else
		setPropertyFromGroup('unspawnNotes', index, property, setter);
	end
end