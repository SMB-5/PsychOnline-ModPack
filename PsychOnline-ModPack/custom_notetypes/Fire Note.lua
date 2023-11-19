function onCreate()
	luaDebugMode = true;

	makeAnimatedLuaSprite('fireNoteCache', 'notes/fireNote');
	setObjAlpha('fireNoteCache', 0.00001);
	addLuaSprite('fireNoteCache');
	setObjectCamera('fireNoteCache', 'hud');
	
	makeAnimatedLuaSprite('smokeSplashCache', 'notes/notesplashes/smokeSplash');
	setObjAlpha('smokeSplashCache', 0.00001);
	addLuaSprite('smokeSplashCache');
	setObjectCamera('smokeSplashCache', 'hud');
	
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if unspawnProperty(i, 'noteType') == 'Fire Note' then
			unspawnProperty(i, 'texture', 'notes/fireNote');
			unspawnProperty(i, 'rgbShader.enabled', false);
			unspawnProperty(i, 'flipY', downscroll);
			unspawnProperty(i, 'ignoreNote', true);
			unspawnProperty(i, 'lowPriority', true);
			unspawnProperty(i, 'hitCausesMiss', true);
			unspawnProperty(i, 'missHealth', 0.8);
			unspawnProperty(i, 'earlyHitMult', 0.4);
			unspawnProperty(i, 'lateHitMult', 0.6);
			unspawnProperty(i, 'offsetX', -50);
			unspawnProperty(i, 'offsetY', (downscroll and -202 or -57.75));
		end
	end
	
	for i = getProperty('unspawnNotes.length') - 1, 0, -1 do
		if unspawnProperty(i, 'noteType') == 'Fire Note' and unspawnProperty(i, 'isSustainNote') then
			removeFromGroup('unspawnNotes', i, false);
		end
	end
	
	addHaxeLibrary('Note', 'objects');
	runHaxeCode([[
		var notesArray = Note.colArray;
		createCallback('notePrefixBLUE', function(i) {
			var curNote = game.notes.members[i];
			
			curNote.animation.addByPrefix('greenScroll', notesArray[2] + '0');
			curNote.animation.play('greenScroll');
			curNote.flipX = true;
		});
		
		createCallback('notePrefixGREEN', function(i) {
			var curNote = game.notes.members[i];
			
			curNote.animation.addByPrefix('blueScroll', notesArray[1] + '0');
			curNote.animation.play('blueScroll');
			curNote.flipX = true;
		});
		
		createCallback('setNoteFrameRate', function(i, f) {
			game.notes.members[i].animation.curAnim.frameRate = f;
		});
		
		createCallback('noteSplashSetter', function(i) {
			var curNote = game.notes.members[i];
			var splash = curNote.noteSplashData;
			
			splash.texture = 'notes/notesplashes/smokeSplash';
			splash.useRGBShader = false;
			splash.disabled = true;
			splash.a = 1;
			
			game.spawnNoteSplash(curNote.x + 76, curNote.y + (ClientPrefs.data.downScroll ? 202 : 70), curNote.noteData, curNote);
		});
	]]);
end

function onCreatePost()
	precacheSound('burnSound');
end

function onSpawnNote(i, d, n)
	if n == 'Fire Note' then
		if downscroll and (d == 1 or d == 2) then _G['notePrefix' .. (d == 1 and 'BLUE' or 'GREEN')](i); end
		setNoteFrameRate(i, 30);
	end
end

function noteMiss(i, d, n)
	if n == 'Fire Note' then
		doSound('burnSound');
		noteSplashSetter(i);
	end
end

function unspawnProperty(index, property, setter)
	if setter == nil then 
		return getPropertyFromGroup('unspawnNotes', index, property);
	else
		setPropertyFromGroup('unspawnNotes', index, property, setter);
	end
end